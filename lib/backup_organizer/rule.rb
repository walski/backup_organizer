module BackupOrganizer
  class Rule
    def initialize(directory)
      @directory = directory
    end

    def when(&rule)
      @rule = rule
    end

    def applies_for?(file)
      @rule.call(file)
    end

    def directory
      @directory
    end
  end
end