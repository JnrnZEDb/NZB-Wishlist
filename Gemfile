source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'bootstrap-sass', '~> 3.3.4'
gem 'bootswatch-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'requirejs-rails'
gem 'turbolinks'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'delayed_job_active_record'
gem 'daemons'
gem 'whenever', require: false
gem 'httparty'

group :development, :test do
    gem 'sqlite3'
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug'
    # Access an IRB console on exception pages or by using <%= console %> in views
    gem 'web-console', '~> 2.0'
    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    # Deployment
    gem 'mina'
    gem 'mina-delayed_job', require: false
    # Tests
    gem 'rspec-rails'
    gem 'factory_girl_rails'
end

group :test do
    gem 'shoulda-matchers'
    gem 'webmock', require: 'webmock/rspec'
    gem 'vcr'
end

group :production do
    gem 'pg'
end