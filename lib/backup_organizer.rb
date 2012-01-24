require "backup_organizer/version"
require "backup_organizer/file_age"
require "backup_organizer/extensions/file_extensions"
require "backup_organizer/error/base_error"
Dir[File.expand_path('../backup_organizer/error/**/*.rb', __FILE__)].each {|f| require f}
require "backup_organizer/file_utils"
require "backup_organizer/rule"
require "backup_organizer/pattern"
require "backup_organizer/configuration"
require "backup_organizer/setup"
require "backup_organizer/file_mover"

module BackupOrganizer
  def self.organize(path)
    pattern = Pattern.new do |files|
      yield files
    end
    configuration = Configuration.new(:path => path, :pattern => pattern)
    Setup.create_structure(configuration)
    configuration.move_all_files
  end
end