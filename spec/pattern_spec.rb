require 'spec_helper'

describe BackupOrganizer::Pattern do
  subject {
    BackupOrganizer::Pattern.new do |files|
      files.stored_in('daily' ).when {|f| true}
      files.stored_in('weekly').when {|f| true}
      files.stored_in('yearly').when {|f| true}
    end
  }

  it "can list all directories it needs" do
    subject.directories.should eq %w{daily weekly yearly}
  end
end