module BackupOrganizer
  class Pattern
    def initialize
      yield self
    end

    def stored_in(directory)
      rule = Rule.new(directory)
      rules << rule
      rule
    end

    def directories
      rules.map &:directory
    end

    def rules
      @rules ||= []
    end
  end
end