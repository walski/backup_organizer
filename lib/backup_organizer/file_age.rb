module BackupOrganizer
  class FileAge < BasicObject
    include ::Comparable

    def initialize(age)
      @age = age
    end

    def <=>(b)
      b = b.to_f if b.respond_to?(:to_f)
      @age.<=>(b)
    end

    def respond_to?(method)
      @age.respond_to?(method)
    end

    def is_a?(klass)
      FileAge == klass || @age.is_a?(klass)
    end
    alias :kind_of? :is_a?

    def method_missing(name, *attrs)
      @age.send(name, *attrs)
    end
  end
end