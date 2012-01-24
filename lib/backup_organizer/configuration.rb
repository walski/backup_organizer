require "backup_organizer/file_mover"

module BackupOrganizer
  class Configuration
    attr_reader :path, :pattern
    def initialize(options)
      @path, @pattern = options[:path], options[:pattern]

      raise Error::ConfigurationError.new('No path set') unless @path
      raise Error::ConfigurationError.new('No pattern set') unless @path
    end

    def directories
      pattern.directories.map {|directory| File.expand_path("./#{directory}", @path)}
    end

    def move_all_files
      sources = directories
      destinations = (directories << :delete)[1..-1]
      sources.each_with_index do |source, i|
        FileMover.move_files(source, @pattern.rules[i], destinations[i])
      end
    end
  end
end