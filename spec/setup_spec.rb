require 'spec_helper'
require 'tempfile'

describe BackupOrganizer::Setup do
  before do
    path = Tempdir.new
    @configuration = mock(BackupOrganizer::Configuration, :path => path, :directories => %w{daily weekly yearly}.map {|e| File.expand_path("./#{e}", path)})
  end

  describe "creating the structure" do
    describe "raises an error when" do
      it "the path is not a directory" do
        file = Tempfile.new('backup_organizer_fake_dir')
        path = file.path
        @configuration.stub(:path).and_return(path)
        file.unlink
        lambda {
          BackupOrganizer::Setup.create_structure(@configuration)
        }.should raise_error(BackupOrganizer::Error::InvalidPathError)
      end

      it "the path is a file" do
        file = Tempfile.new('backup_organizer_fake_dir')
        path = file.path
        @configuration.stub(:path).and_return(path)
        lambda {
          BackupOrganizer::Setup.create_structure(@configuration)
        }.should raise_error(BackupOrganizer::Error::InvalidPathError)
        file.unlink
      end
    end

    it "results in having all the needed directories present" do
      BackupOrganizer::Setup.create_structure(@configuration)
      @configuration.directories.each do |necessary_directory|
        File.directory?(necessary_directory).should be true
      end
    end

    it "leaves an existing structure intact" do
      BackupOrganizer::Setup.create_structure(@configuration)
      files = %w{some test files}
      require 'backup_organizer/file_utils'
      @configuration.directories.each do |directory|
        files.each do |file|
          BackupOrganizer::FileUtils.touch(File.expand_path("./#{file}", directory))
        end
      end

      BackupOrganizer::Setup.create_structure(@configuration)

      @configuration.directories.each do |directory|
        files.each do |file|
          File.exist?(File.expand_path("./#{file}", directory)).should be true
        end
      end
    end
  end
end