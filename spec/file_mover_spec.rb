require 'spec_helper'

describe BackupOrganizer::FileMover do
  describe "moving a single file to a destination" do
    before do
      @path = Tempfile.new('background_organizer_file').path
      @destination = Tempdir.new
      @expected_path = File.expand_path("./#{File.basename(@path)}", @destination)
    end

    it "is carried out when the rule applies" do
      rule = mock(BackupOrganizer::Rule, :applies_for? => false)
      BackupOrganizer::FileMover.move_file(@path, rule, @destination)
      File.exist?(@path).should be true
      File.exist?(@expected_path).should be false
    end

    it "is not carried out when the rule does not apply" do
      rule = mock(BackupOrganizer::Rule, :applies_for? => true)
      BackupOrganizer::FileMover.move_file(@path, rule, @destination)
      File.exist?(@path).should be false
      File.exist?(@expected_path).should be true
    end

    it "deletes the file if the destination is :delete" do
      rule = mock(BackupOrganizer::Rule, :applies_for? => true)
      BackupOrganizer::FileMover.move_file(@path, rule, :delete)
      File.exist?(@path).should be false
      File.exist?(@expected_path).should be false
    end
  end
  
  it "moves all files in a directory that match a rule" do
    directory = Tempdir.new
    %w{some test-1 files with different-1 looks}.each {|f| FileUtils.touch(File.expand_path("./#{f}", directory))}
    rule = mock(BackupOrganizer::Rule)
    def rule.applies_for?(file)
      file =~ /-1$/
    end
    destination = Tempdir.new

    BackupOrganizer::FileMover.move_files(directory, rule, destination)

    File.exist?(File.expand_path("./some", directory)       ).should be true
    File.exist?(File.expand_path("./files", directory)      ).should be true
    File.exist?(File.expand_path("./with", directory)       ).should be true
    File.exist?(File.expand_path("./looks", directory)      ).should be true
    File.exist?(File.expand_path("./test-1", directory)     ).should be false
    File.exist?(File.expand_path("./different-1", directory)).should be false

    File.exist?(File.expand_path("./some", destination)       ).should be false
    File.exist?(File.expand_path("./files", destination)      ).should be false
    File.exist?(File.expand_path("./with", destination)       ).should be false
    File.exist?(File.expand_path("./looks", destination)      ).should be false
    File.exist?(File.expand_path("./test-1", destination)     ).should be true
    File.exist?(File.expand_path("./different-1", destination)).should be true
  end
end