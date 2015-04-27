FactoryGirl.define do
    factory :setting do
        newsnab_url Rails.application.secrets.newsnab_url
        newsnab_apikey Rails.application.secrets.newsnab_key
        result_limit 10
        search_interval 2
        sabnzbd_url Rails.application.secrets.sabnzbd_url
        sabnzbd_apikey Rails.application.secrets.sabnzbd_key
        pushover_apikey Rails.application.secrets.pushover_key
        setup_complete true
    end
end