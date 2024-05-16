module LtfsTapeWatcher
  class Config
    def self.instance(config_hash = {} of Symbol => String)
      @@instance ||= new(config_hash)
    end

    def initialize(config_hash = {} of Symbol => String)
      @config_hash = config_hash
    end

    def mount_point
      "/mnt/ltfs"
    end

    def loop_delay
      30 # seconds
    end

    def mt_device
      "/dev/nst0"
    end

    def sg_device
      "/dev/sg2"
    end
  end

  def self.config
    Config.instance
  end
end