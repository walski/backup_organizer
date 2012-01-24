# BackupOrganizer [![Build Status](https://secure.travis-ci.org/walski/backup_organizer.png)](http://travis-ci.org/walski/backup_organizer)

This gem helps you to keep your backups organized and to let the density of kept files to fade out over time.

The rules of how you want your backups organized are described in a Pattern like this:

## Installation

Add this line to your application's Gemfile:

    gem 'backup_organizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install backup_organizer

## Usage

### Scenario
* You are doing daily backups.
* The goal is to have a script that you can run daily and that ensures, that
  * all the backups of the last 30 days around are kept
  * one file per month for the last year around is kept
  * one file per year forever around is kept
  * all other files get deleted

### Solution

#### How it looks like

```ruby
# Load ActiveSupport to make date wrangling a bit more convenient
require 'rubygems'
require 'active_support/core_ext'

# Define the pattern
BackupOrganizer.organize('/basepath/to/your/backups') do |files|
  files.stored_in('daily').if {|file| file.created_after?(30.days.ago)}
  
  files.stored_in('monthly').if do |file|
    file.created_after?(Time.now.beginning_of_year) && 
    file.most_recent_in_creation_month?
  end
  
  files.stored_in('yearly').if {|file| file.most_recent_in_creation_year?}
end
````

#### What it does

Given that pattern you should drop all your backups in ``/basepath/to/your/backups/daily``. The organizer then does the following:

1. Move all files in ``/basepath/to/your/backups/daily`` which
  * are not created in the current month
  
    to ``/basepath/to/your/backups/monthly``
  
2. Move all files in ``/basepath/to/your/backups/monthly`` which
  * are not created in the current year
  * are among all the files created in the same month **not** most recent file
  
    to ``/basepath/to/your/backups/yearly``
  
3. **Delete** (as this is the last rule) all files in ``/basepath/to/your/backups/monthly`` which
  * are among all the files created in the same year **not** the most recent file
  
#### What else?

If you run the script make sure at least the ``/basepath/to/your/backups`` directory exists, the BackupOrganizer will take care of getting everything else in place.