require 'backup_organizer/file_utils'

module BackupOrganizer
  class Setup
    def self.create_structure(configuration)
      @configuration = configuration
      raise Error::InvalidPathError unless File.exist?(@configuration.path) && File.directory?(@configuration.path)

      @configuration.directories.each do |necessary_directory|
        next if File.directory?(necessary_directory)
        raise Error::SetupError.new('`#{necessary_directory}` should be a directory but is a file.') if File.exist?(necessary_directory)
        BackupOrganizer::FileUtils.mkdir(necessary_directory)
      end
    end
  end
end