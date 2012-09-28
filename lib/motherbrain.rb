require 'json'
require 'fileutils'
require 'pathname'
require 'set'
require 'ridley'
require 'solve'

require 'mb/version'
require 'mb/errors'

# @author Jamie Winsor <jamie@vialstudios.com>
module MotherBrain
  autoload :Config, 'mb/config'
  autoload :CliBase, 'mb/cli_base'
  autoload :Cli, 'mb/cli'
  autoload :Plugin, 'mb/plugin'
  autoload :PluginLoader, 'mb/plugin_loader'
  autoload :Component, 'mb/component'
  autoload :Command, 'mb/command'
  autoload :Group, 'mb/group'

  class << self
    def ui
      @ui ||= Thor::Shell::Color.new
    end

    def root
      @root ||= Pathname.new(File.expand_path('../', File.dirname(__FILE__)))
    end
  end
end

unless defined?(MB)
  # Alias for {MotherBrain}
  MB = MotherBrain
end
