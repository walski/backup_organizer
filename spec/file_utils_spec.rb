require 'spec_helper'

describe BackupOrganizer::FileUtils do
  it "knows the age of a file" do
    path = temp_file_at(Time.now - 3.days)
    BackupOrganizer::FileUtils.age_of(path).should be_within(1).of(3.days)
    path = temp_file_at(Time.now - 99.days)
    BackupOrganizer::FileUtils.age_of(path).should be_within(1).of(99.days)
    path = temp_file_at(Time.now - 17.years)
    BackupOrganizer::FileUtils.age_of(path).should be_within(1).of(17.years)
  end
end