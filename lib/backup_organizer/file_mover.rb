require 'backup_organizer/file_utils'

module BackupOrganizer
  class FileMover
    def self.move_files(source, rule, destination)
      Dir[File.expand_path('./*', source)].each do |file|
        move_file(file, rule, destination)
      end
    end

    def self.move_file(file, rule, destination)
      return if rule.applies_for?(file)
      return FileUtils.rm_rf(file) if destination == :delete

      FileUtils.mv(file, destination)
    end
  end
end