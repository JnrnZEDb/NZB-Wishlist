# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'support/helpers'
require 'vcr'

real_requests = ENV['REAL_REQUESTS']
puts "\e[034m*\e[0m Live API calls are being made!" if real_requests

VCR.configure do |config|
    config.hook_into :webmock
    config.cassette_library_dir = 'spec/support/vcr_cassettes'
    config.configure_rspec_metadata!
    config.allow_http_connections_when_no_cassette = true if real_requests
    config.default_cassette_options = { record: :new_episodes }
    config.filter_sensitive_data('<SABNZBD_URL>')     { Rails.application.secrets.sabnzbd_url  }
    config.filter_sensitive_data('<SABNZBD_APIKEY>')  { Rails.application.secrets.sabnzbd_key  }
    config.filter_sensitive_data('<NEWSNAB_URL>')     { Rails.application.secrets.newsnab_url  }
    config.filter_sensitive_data('<NEWSNAB_APIKEY>')  { Rails.application.secrets.newsnab_key  }
    config.filter_sensitive_data('<PUSHOVER_APIKEY>') { Rails.application.secrets.pushover_key }
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
    config.before(:each) do
        VCR.eject_cassette
    end if real_requests

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    config.include FactoryGirl::Syntax::Methods
    config.include Helpers

    config.use_transactional_fixtures = true
    config.infer_spec_type_from_file_location!
end