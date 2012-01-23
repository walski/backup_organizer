module BackupOrganizer
  class Configuration
    attr_reader :path, :pattern
    def initialize(options)
      @path, @pattern = options[:path], options[:pattern]

      raise Error::InvalidConfiguration.new('No path set') unless @path
      raise Error::InvalidConfiguration.new('No pattern set') unless @path
    end

    def directories
      pattern.directories.map {|directory| File.expand_path("./#{directory}", @path)}
    end
  end
end