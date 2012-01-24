require 'spec_helper'

def check_expectations(expectations, method)
  dir = Tempdir.new
  files = []

  # Create all the files first
  expectations.each do |date, expectation|
    path = temp_file_at(date, dir).extend(BackupOrganizer::Extensions::FileExtensions)
    files << [date, path, expectation]
  end

  # Check for the expectations
  files.each do |date, path, expectation|
    path.send(method).should be(expectation), "File with mtime of #{date} should return #{expectation} to #{method} but didn't"
  end
end

describe BackupOrganizer::Extensions::FileExtensions do
  it "can tell a file's age" do
    file = '/tmp/some/path'
    file.extend BackupOrganizer::Extensions::FileExtensions
    BackupOrganizer::FileUtils.should_receive(:age_of).with(file).and_return(1.234)
    age = file.age
    age.kind_of?(BackupOrganizer::FileAge).should be true
    age.should eq 1.234
  end

  it "can tell if a file is the most recent one in the same hour of it's last modification (mtime)" do
    time = Time.now

    first_of_this_hour = Time.local(time.year, time.month, time.day, time.hour)
    last_of_last_hours = first_of_this_hour - 1
    mid_of_this_hour   = first_of_this_hour + 30.minutes
    first_of_next_hour = first_of_this_hour + 1.hour
    
    expectations = {
      first_of_this_hour => false,
      last_of_last_hours => true,
      mid_of_this_hour => true,
      first_of_next_hour => true
    }

    check_expectations(expectations, :most_recent_in_its_hour?)
  end

  it "can tell if a file is the most recent one in the same day of it's last modification (mtime)" do
    time = Time.now

    midnight = Time.local(time.year, time.month, time.day)
    
    first_of_this_day  = midnight
    last_of_last_day   = first_of_this_day - 1
    mid_of_this_day    = first_of_this_day + 12.hours
    first_of_next_day  = first_of_this_day + 24.hours
    
    expectations = {
      first_of_this_day => false,
      last_of_last_day => true,
      mid_of_this_day => true,
      first_of_next_day => true
    }

    check_expectations(expectations, :most_recent_in_its_day?)
  end

  it "can tell if a file is the most recent one in the same week of it's last modification (mtime)" do
    time = Time.now

    midnight = Time.local(time.year, time.month, time.day)
    first_of_this_week  = midnight - (midnight.wday - 1).days
    first_of_this_week -= 7.days if midnight.wday == 0
    last_of_last_week   = first_of_this_week - 1
    mid_of_this_week    = first_of_this_week + 3.days
    first_of_next_week  = first_of_this_week + 7.days
    
    expectations = {
      first_of_this_week => false,
      last_of_last_week => true,
      mid_of_this_week => true,
      first_of_next_week => true
    }

    check_expectations(expectations, :most_recent_in_its_week?)
  end

  it "can tell if a file is the most recent one in the same month of it's last modification (mtime)" do
    time = Time.now

    first_of_this_month = Time.local(time.year, time.month, 1)
    last_of_last_month  = first_of_this_month - 1
    mid_of_this_month   = first_of_this_month + 15.days
    next_month          = (first_of_this_month + 32.days)
    first_of_next_month = Time.local(next_month.year, next_month.month, 1)
    
    expectations = {
      first_of_this_month => false,
      last_of_last_month => true,
      mid_of_this_month => true,
      first_of_next_month => true
    }

    check_expectations(expectations, :most_recent_in_its_month?)
  end

  it "can tell if a file is the most recent one in the same year of it's last modification (mtime)" do
    time = Time.now

    first_of_this_year = Time.local(time.year, 1, 1)
    last_of_last_year  = first_of_this_year - 1    
    mid_of_this_year   = first_of_this_year + 180.days
    first_of_next_year = Time.local(first_of_this_year.year + 1, 1, 1)
    
    expectations = {
      first_of_this_year => false,
      last_of_last_year => true,
      mid_of_this_year => true,
      first_of_next_year => true
    }

    check_expectations(expectations, :most_recent_in_its_year?)
  end
end