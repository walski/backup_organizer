require 'spec_helper'
require 'tempfile'

describe BackupOrganizer::Configuration do
  it "returns the full path to all the directories of it's pattern" do
    path = Tempdir.new
    pattern = mock(BackupOrganizer::Pattern, :directories => %w{daily weekly yearly})
    configuration = BackupOrganizer::Configuration.new(:path => path, :pattern => pattern)
    configuration.directories.should eq pattern.directories.map {|d| File.expand_path("./#{d}", path)}
  end

  it "runs the file mover for all rules/destinations" do
    path = Tempdir.new
    rule1 = mock(BackupOrganizer::Rule, :path => 'daily')
    rule2 = mock(BackupOrganizer::Rule, :path => 'weekly')
    rule3 = mock(BackupOrganizer::Rule, :path => 'yearly')
    pattern = mock(BackupOrganizer::Pattern, :directories => %w{daily weekly yearly}, :rules => [rule1, rule2, rule3])
    configuration = BackupOrganizer::Configuration.new(:path => path, :pattern => pattern)

    BackupOrganizer::FileMover.should_receive(:move_files).with(File.expand_path("./#{rule1.path}", path), rule1, File.expand_path("./#{rule2.path}", path)).ordered
    BackupOrganizer::FileMover.should_receive(:move_files).with(File.expand_path("./#{rule2.path}", path), rule2, File.expand_path("./#{rule3.path}", path)).ordered
    BackupOrganizer::FileMover.should_receive(:move_files).with(File.expand_path("./#{rule3.path}", path), rule3, :delete).ordered

    configuration.move_all_files
  end
end