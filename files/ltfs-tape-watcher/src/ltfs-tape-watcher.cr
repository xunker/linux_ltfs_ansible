# TODO: Write documentation for `Ls`
module LtfsTapeWatcher
  VERSION = "0.1.0"

  # TODO: Put your code here
end
require "log"

require "./lib/config"
require "./lib/mount_point"
require "./lib/tape_device"
require "./lib/runner"

# # puts LtfsTapeWatcher.config.mount_point
# mount = LtfsTapeWatcher::MountPoint.new(LtfsTapeWatcher.config.mount_point)
# puts mount.to_s
# puts mount.valid?

config_file_path = "ltfs-tape-wather.yaml"

require "option_parser"
OptionParser.parse do |parser|
  parser.banner = <<-BANNER
LTFS Tape Watcher v#{LtfsTapeWatcher::VERSION}

usage: ltfs-tape-watcher [arguments]
BANNER

  parser.on "-c PATH", "--config PATH", "Specify Configuration File" do |path|
    config_file_path = path
  end

  parser.on "-v", "--version", "Show version" do
    puts LtfsTapeWatcher::VERSION
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.missing_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is missing something."
    STDERR.puts ""
    STDERR.puts parser
    exit(1)
  end
  parser.invalid_option do |option_flag|
    STDERR.puts "ERROR: #{option_flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end
LtfsTapeWatcher::Runner.new(LtfsTapeWatcher.config).start