module LtfsTapeWatcher
  class TapeDevice
    def initialize(mt_device : String, sg_device : String)
      @mt_device = mt_device
      @sg_device = sg_device
    end
  end
end