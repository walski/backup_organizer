require 'spec_helper'

describe BackupOrganizer::Rule do
  subject {BackupOrganizer::Rule.new('/tmp/dir')}

  it "knows it's directory" do
    subject.directory.should eq '/tmp/dir'
  end

  it "can tell if the rule apply to a certain file" do
    subject.when {|f| f.applies}

    file = mock(File, :applies => false)
    subject.applies_for?(file).should be false

    file = mock(File, :applies => true)
    subject.applies_for?(file).should be true
  end
end