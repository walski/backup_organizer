require 'spec_helper'

describe BackupOrganizer::Rule do
  subject {BackupOrganizer::Rule.new('/tmp/dir')}

  it "knows it's directory" do
    subject.directory.should eq '/tmp/dir'
  end

  it "can tell if the rule apply to a certain file" do
    subject.if {|f| f.applies}

    file = mock(File, :applies => false)
    subject.applies_for?(file).should be false

    file = mock(File, :applies => true)
    subject.applies_for?(file).should be true
  end

  it "mixes the FileExtensions in to each yielded path" do
    subject.if{|f| (class << f; self; end).included_modules.include?(BackupOrganizer::Extensions::FileExtensions).should be true}
    file = mock(File, :applies => true)
    subject.applies_for?(file)
  end
end