module LtfsTapeWatcher
  class MountPoint
    def initialize(path : String)
      @path = path
    end

    def path
      @path
    end

    def valid?
      exists?
    end

    def exists?
      Dir.exists?(path)
    end

    def to_s
      "Mount Point: #{path}"
    end
  end
end