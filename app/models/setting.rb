class Setting < ActiveRecord::Base
    before_save :complete_setup

    validates :newsnab_url,    presence: { message: "Newsnab URL is required!" },
                               format: { with: URI::regexp, message: 'Not a valid url!' }
    validates :newsnab_apikey, presence: { message: "Newsnab API key is required!" }
    validates :sabnzbd_url,    presence: { message: "SABnzbd URL is required!" },
                               format: { with: URI::regexp, message: 'Not a valid url!' }
    validates :sabnzbd_apikey, presence: { message: "SABnzbd API key is required!" }
    validates :result_limit,   numericality: {
        only_integer: true,
        greater_than_or_equal_to: 1,
        less_than_or_equal_to:    100,
        message: "Result limit must be in the range of 1-100!"
    }
    validates :search_interval, numericality: {
        only_integer: true,
        greater_than_or_equal_to: 1,
        less_than_or_equal_to:    24,
        message: "Search interval must be between 1 and 24 hours!"
    }
    validates :pushover_apikey,
              if: :notify?,
              presence: { message: "Pushover API key is required when notifications are enabled." }

    def update_schedule?
        @update_schedule.nil? ? false : @update_schedule
    end

    private

    def complete_setup
        unless self.setup_complete?
            self.setup_complete = true
        end
        @update_schedule = self.search_interval_changed?
        true # a false value triggers a rollback
    end
end
