module LtfsTapeWatcher
  class Runner
    def initialize(config : Config)
      @config = config
      @mount_point = MountPoint.new(@config.mount_point)
      @tape_device = TapeDevice.new(
        mt_device: @config.mt_device,
        sg_device: @config.sg_device
      )
    end

    def config
      @config
    end

    def start
      Log.info { "Starting Loop" }
      loop do
        process
        Log.info { "Sleeping #{config.loop_delay} seconds"}
        sleep(config.loop_delay)
      end
    end

    def process
      if @mount_point.mounted?
        Log.info { "#{@mount_point} is occupied" }
        return
      end

      if @tape_device.mounted?
        Log.info { "#{@tape_device} is already mounted at #{@tape_device.mount_point}" }
        return
      end

      unless @tape_device.ready?
        Log.info { "#{@tape_device} is not yet ready" }
        return
      end

      unless @tape_device.tape_present?
        Log.info { "No tape present in #{@tape_device}" }
        return
      end

      Log.info { "Current tape: #{tape_device.tape_info}" }

      unless @tape_device.tape_is_ltfs?
        Log.info { "Current tape is not formatted as LTFS" }
        Log.debug { "Expected Tape \"Application Name\" to be \"LTFS\", but is #{@tape_device.tape_application_name}" }
        return
      end

      unless @tape_device.mount(mount_point: @mount_point.path)
        Log.warn { "Could not mount #{@tape_device}. Error: #{@tape_device.last_error}" }
        exit(1)
      end

      if @tape_device.error?
        Log.warn { "Tape Error: #{@tape_device.last_error}" }
        exit(1)
      end

      Log.info { "Free space on tape: #{@tape_device.free_space}" }
    end
  end
end