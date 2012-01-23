require 'tempfile'
require 'fileutils'

class Tempdir
  def self.new
    file = Tempfile.new("backup_spec_temp_dir")
    path = file.path
    file.unlink
    Dir.mkdir(path)
    path
  end
end