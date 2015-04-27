module Helpers
    # Define Rails secret keys as helper methods
    [:sabnzbd_url, :sabnzbd_key, :newsnab_url, :newsnab_key, :pushover_key].each do |key|
        define_method(key) { Rails.application.secrets.send(key) }
    end
end