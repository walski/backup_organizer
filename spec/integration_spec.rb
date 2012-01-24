require 'spec_helper'
require 'find'

def include_files(dir_name, actual, expected, expectation)
  expected.each do |file|
    basename = File.basename(file)
    actual.include?(basename).should be(expectation), "#{dir_name} should#{expectation ? '' : ' not'} include #{basename} but does #{expectation ? 'not' : ''}."
  end
end

describe "integration of the whole system" do
  before do
    @now = Time.local(Time.now.year, 12, 30) 
    Time.stub(:now).and_return(@now)

    @base_path = Tempdir.new
    @daily_destination   = File.expand_path("./daily", @base_path)
    @monthly_destination = File.expand_path("./monthly", @base_path)
    @yearly_destination  = File.expand_path("./yearly", @base_path)
    BackupOrganizer::FileUtils.mkdir(@daily_destination)
    BackupOrganizer::FileUtils.mkdir(@yearly_destination)

    @file_01_day_ago             = temp_file_at(Time.now - 1.day + 2,                         @daily_destination)
    @file_04_days_ago            = temp_file_at(Time.now - 10.days + 2,                       @yearly_destination)
    @file_10_days_ago            = temp_file_at(Time.now - 10.days + 2,                       @daily_destination)
    @file_30_days_ago            = temp_file_at(Time.now - 30.days + 2,                       @daily_destination)
    @file_31_days_ago            = temp_file_at(Time.now - 31.days + 2,                       @daily_destination)
    @file_02_month_ago           = temp_file_at(Time.now - 60.days + 2,                       @daily_destination)
    @file_02_month_and_a_bit_ago = temp_file_at(Time.now - 65.days + 2,                       @daily_destination)
    @file_06_month_ago           = temp_file_at(Time.now - 180.days + 2,                      @daily_destination)
    @file_07_month_ago           = temp_file_at(Time.now - 240.days + 2,                      @yearly_destination)
    @file_365_days_ago           = temp_file_at(Time.now - 365.days + 2,                      @daily_destination)
    @file_366_days_ago           = temp_file_at(Time.now - 366.days + 2,                      @daily_destination)
    time_366_days_ago = Time.now - 366.days                                               
    @file_a_year_and_a_bit_ago   = temp_file_at(Time.local(time_366_days_ago.year, 1, 1) + 2, @daily_destination)
    @file_three_years_ago        = temp_file_at(Time.now - 3.years + 2,                       @yearly_destination)
    @file_ten_years_ago          = temp_file_at(Time.now - 10.years + 2,                      @yearly_destination)
  end

  after do
    Time.unstub(:now)
    BackupOrganizer::FileUtils.rm_rf @base_path
  end

  it "works fine" do
    BackupOrganizer.organize(@base_path) do |files|
      files.stored_in('daily').if {|file| file.age < 30.days}

      files.stored_in('monthly').if do |file|
        file.age < 1.year && 
        file.most_recent_in_its_month?
      end

      files.stored_in('yearly').if {|file| file.most_recent_in_its_year?}
    end

    expected_in_daily = [
       @file_01_day_ago,
       @file_10_days_ago,
       @file_30_days_ago
    ]
    
    expected_in_monthly = [
      @file_31_days_ago,
      @file_02_month_ago,
      @file_06_month_ago,
      @file_365_days_ago
    ]

    expected_in_yearly = [
      @file_04_days_ago,
      @file_366_days_ago,
      @file_three_years_ago,
      @file_ten_years_ago
    ]

    expected_deleted = [
      @file_07_month_ago,
      @file_a_year_and_a_bit_ago,      
      @file_02_month_and_a_bit_ago
    ]

    dailies   = files_in(File.expand_path('./daily', @base_path))
    monthlies = files_in(File.expand_path('./monthly', @base_path))
    yearlies  = files_in(File.expand_path('./yearly', @base_path))

    include_files(:dailies, dailies, expected_in_daily, true)
    include_files(:dailies, dailies, expected_in_monthly + expected_in_yearly + expected_deleted, false)

    include_files(:monthlies, monthlies, expected_in_monthly, true)
    include_files(:monthlies, monthlies, expected_in_daily + expected_in_yearly + expected_deleted, false)

    include_files(:yearlies, yearlies, expected_in_yearly, true)
    include_files(:yearlies, yearlies, expected_in_daily + expected_in_monthly + expected_deleted, false)
  end
end