require 'spec_helper'

describe BackupOrganizer::FileAge do
  it "can be compared with Time" do
    age = BackupOrganizer::FileAge.new(Time.now - 2.days)
    age.should < (Time.now - 1.day)
    age.should_not > (Time.now - 1.day)
    age.should > (Time.now - 3.days)
    age.should_not < (Time.now - 3.days)
  end
end