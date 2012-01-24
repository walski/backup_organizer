module BackupOrganizer
  class Rule
    def initialize(directory)
      @directory = directory
    end

    def if(&rule)
      @rule = rule
    end

    def applies_for?(file)
      file.extend(Extensions::FileExtensions)
      @rule.call(file)
    end

    def directory
      @directory
    end
  end
end