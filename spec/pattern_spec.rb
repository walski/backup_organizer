require 'spec_helper'

describe BackupOrganizer::Pattern do
  subject {
    BackupOrganizer::Pattern.new do |files|
      files.stored_in('daily' ).if {|f| true}
      files.stored_in('weekly').if {|f| true}
      files.stored_in('yearly').if {|f| true}
    end
  }

  it "can list all directories it needs" do
    subject.directories.should eq %w{daily weekly yearly}
  end
end