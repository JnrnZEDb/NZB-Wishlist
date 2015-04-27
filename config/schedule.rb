# Load the Rails environment so the schedule can be reset
# according to user settings
require File.expand_path('../environment', __FILE__)

set :search_interval, Setting.first.search_interval
set :chruby_path,     '/usr/local/share/chruby'
set :chruby,          "source #{chruby_path}/chruby.sh"
set :auto,            "source #{chruby_path}/auto.sh"
set :job_template,    "/bin/bash -l -c '#{chruby} && #{auto} && :job'"

every search_interval.hours do
  rake 'wishlist:tasks:search'
end