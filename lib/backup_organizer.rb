require "backup_organizer/version"
require "backup_organizer/error/base_error"
Dir[File.expand_path('../backup_organizer/error/**/*.rb', __FILE__)].each {|f| require f}
require "backup_organizer/rule"
require "backup_organizer/pattern"
require "backup_organizer/configuration"
require "backup_organizer/setup"
require "backup_organizer/file_mover"

module BackupOrganizer
  # Your code goes here...
end