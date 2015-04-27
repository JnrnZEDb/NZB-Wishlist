class UpdateSearchScheduleJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
        domain = '[YOUR DOMAIN]' # Put the domain from your config/deploy.rb here
        system "bundle exec whenever --update-crontab #{domain}_#{Rails.env}"
    end

end