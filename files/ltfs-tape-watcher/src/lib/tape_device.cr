module LtfsTapeWatcher
  class TapeDevice
    def initialize(mt_device : String, sg_device : String)
      @mt_device = mt_device
      @sg_device = sg_device
    end

    def to_s
      "Tape(#{@mt_device}, #{@sg_device})"
    end

    def mounted?
      false
    end

    def mount_point
      "dunno"
    end

    def ready?
      false
    end

    def tape_present?
      false
    end

    def tape_info
      "some tape"
    end

    def tape_is_ltfs?
      false
    end

    def mount(mount_point : String)
      false
    end

    def last_error
      "oops"
    end

    def free_space
      "very many MiB"
    end

    def tape_application_name
      "ytta"
    end

    def error?
      true
    end
  end
end