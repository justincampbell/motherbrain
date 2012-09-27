module MotherBrain
  # @author Jamie Winsor <jamie@vialstudios.com>
  class PluginLoader
    class << self
      def default_paths
        [ File.expand_path(File.join("~/", ".motherbrain", "plugins")) ]
      end
    end

    # @return [Set<Pathname>]
    attr_reader :paths

    # @param [Array<String>, Array<Pathname>] paths
    def initialize(paths = Array.new)
      @paths = Set.new
      @plugins = Hash.new

      Array(paths).collect { |path| self.add_path(path) }      
    end

    # @return [Array<MotherBrain::Plugin>]
    def plugins
      @plugins.values
    end

    # @param [String] name
    # @param [Version] version
    #
    # @return [MotherBrain::Plugin]
    def plugin(name, version)
      @plugins.fetch(Plugin.key_for(name, version), nil)
    end

    # @raise [AlreadyLoaded] if a plugin of the same name and version has already been loaded
    def load_all
      self.paths.each { |path| self.load(path) }
    end

    # @param [#to_s] path
    #
    # @raise [AlreadyLoaded] if a plugin of the same name and version has already been loaded
    def load(path)
      add Plugin.from_file(path.to_s)
    end

    # @param [String, Pathname] path
    def add_path(path)
      self.paths.add(Pathname.new(path))
    end

    # @param [Pathname] path
    def remove_path(path)
      self.paths.delete(path)
    end

    private

      # @param [MotherBrain::Plugin]
      #
      # @raise [AlreadyLoaded] if a plugin of the same name and version has already been loaded
      def add(plugin)
        if @plugins.has_key?(plugin.id)
          raise AlreadyLoaded, "A plugin with the name: '#{plugin.name}' and version: '#{plugin.version}' is already loaded"
        end

        @plugins[plugin.id] = plugin
      end
  end
end