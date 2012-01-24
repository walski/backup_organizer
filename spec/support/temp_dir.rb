require 'tempfile'
require 'backup_organizer/file_utils'

class Tempdir
  def self.new
    file = Tempfile.new("backup_spec_temp_dir")
    path = file.path
    file.unlink
    BackupOrganizer::FileUtils.mkdir(path)
    path
  end
end