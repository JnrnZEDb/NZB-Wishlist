class UpdateSearchScheduleJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
        domain = 'iroha'
        system "bundle exec whenever --update-crontab #{domain}_#{Rails.env}"
    end

end