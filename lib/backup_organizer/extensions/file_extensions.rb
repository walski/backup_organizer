require "backup_organizer/file_age"
require 'backup_organizer/file_utils'

module BackupOrganizer
  module Extensions
    module FileExtensions
      def age
        FileAge.new(BackupOrganizer::FileUtils.age_of(self))
      end

      def most_recent_in_its_hour?
        mtime     = BackupOrganizer::FileUtils.mtime(self)
        hour      = Time.local(mtime.year, mtime.month, mtime.day, mtime.hour)
        one_hour  = 60 * 60

        most_recent_in?(hour...(hour + one_hour))
      end

      def most_recent_in_its_day?
        mtime     = BackupOrganizer::FileUtils.mtime(self)
        midnight  = Time.local(mtime.year, mtime.month, mtime.day)
        one_day   = 24 * 60 * 60

        most_recent_in?(midnight...(midnight + one_day))
      end

      def most_recent_in_its_week?
        mtime     = BackupOrganizer::FileUtils.mtime(self)
        midnight  = Time.local(mtime.year, mtime.month, mtime.day)
        one_day   = 24 * 60 * 60
        monday    = midnight - ((midnight.wday - 1) * one_day)
        monday = monday - (7 * one_day) if midnight.wday == 0

        most_recent_in?(monday...(monday + (7 * one_day)))
      end

      def most_recent_in_its_month?
        mtime      = BackupOrganizer::FileUtils.mtime(self)
        this_month = Time.local(mtime.year, mtime.month, 1)
        mtime      = this_month + 32.days
        next_month = Time.local(mtime.year, mtime.month, 1)

        most_recent_in?(this_month...next_month)
      end

      def most_recent_in_its_year?
        mtime     = BackupOrganizer::FileUtils.mtime(self)
        this_year = Time.local(mtime.year, 1, 1)
        next_year = Time.local(this_year.year + 1, 1, 1)

        most_recent_in?(this_year...next_year)
      end
      
      protected
      def most_recent_in?(period)
        dir = File.dirname(self)

        files_in_dir = Dir[File.expand_path('./*', dir)]
        files_this_month = files_in_dir.select {|f| period.cover?(FileUtils.mtime(f))}#mtime = FileUtils.mtime(f); mtime >= period.begin && mtime < next_month}

        self == files_this_month.sort {|a,b| File.mtime(a) <=> File.mtime(b)}.last
      end
    end
  end
end