module BackupOrganizer
  class FileUtils
    def self.mv(from, to)
      ::FileUtils.mv(from, to)
    end

    def self.rm_rf(path)
      ::FileUtils.rm_rf(path)
    end

    def self.touch(path)
      ::FileUtils.touch(path)
    end

    def self.mkdir(path)
      Dir.mkdir(path)
    end

    def self.age_of(path)
      Time.now - mtime(path)
    end

    def self.mtime(path)
      File.mtime(path)
    end
  end
end