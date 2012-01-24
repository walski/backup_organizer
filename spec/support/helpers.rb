def temp_file_at(time, destination = nil)
  path = Tempfile.new('backup_organizer_integration_spec').path
  File.utime(time, time, path)
  if destination
    BackupOrganizer::FileUtils.mv path, destination
    File.expand_path("./#{File.basename(path)}", destination)
  else
    path
  end
end

def files_in(path)
  path = "#{File.expand_path('./', path)}/"
  files = []
  Find.find(path) {|file| files << file.gsub(/^#{Regexp.escape(path)}/, '')}
  files.select {|e| !e.empty?}
end

class Fixnum
  def minutes
    self * 60
  end
  alias minute minutes
  
  def hours
    self * 60.minutes
  end
  alias hour hours
  
  def days
    self * 24.hours
  end
  alias day days

  def years
    self * 365.days
  end
  alias year years

  def ago
    Time.now - self
  end
end