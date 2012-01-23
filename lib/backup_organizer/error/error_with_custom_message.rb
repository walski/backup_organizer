module BackupOrganizer
  module Error
    class ErrorWithCustomMessage < BaseError
      attr_reader :message

      def initialize(message)
        @message = message
      end
    end
  end
end