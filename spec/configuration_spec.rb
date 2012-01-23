require 'spec_helper'
require 'tempfile'

describe BackupOrganizer::Configuration do
  before do
    @path = Tempdir.new
    @pattern = mock(BackupOrganizer::Pattern, :directories => %w{daily weekly yearly})
    @configuration = BackupOrganizer::Configuration.new(:path => @path, :pattern => @pattern)
  end

  it "returns the full path to all the directories of it's pattern" do
    @configuration.directories.should eq @pattern.directories.map {|d| File.expand_path("./#{d}", @path)}
  end
end