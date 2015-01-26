source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails',              '4.1.8'
gem 'pg',                 '0.18.1'
gem 'haml-rails',         '0.5.3'
gem 'bootstrap-sass',     '3.3.1.0'
gem 'bootstrap_form',     '2.2.0'
gem 'autoprefixer-rails', '4.0.1.1'
gem 'sass-rails',         '4.0.5'
gem 'font-awesome-rails', '4.3.0.0'
gem 'uglifier',           '2.7.0'
gem 'coffee-rails',       '4.0.1'
gem 'jquery-rails',       '3.1.2'
gem 'turbolinks',         '2.5.3'
gem 'jbuilder',           '2.2.6'
gem 'paratrooper',        '2.4.1'
gem 'sidekiq',            '3.3.0'
gem 'figaro',             '1.0.0'
gem 'omniauth-github',    '1.1.2'
gem 'bcrypt',             '3.1.9'
gem 'nokogiri',           '1.6.5'

group :development do
  gem 'thin',             '1.6.3'
  gem 'hirb',             '0.7.2'
  gem 'quiet_assets',     '1.0.3'
  gem 'letter_opener',    '1.3.0'
end

group :development, :test do  
  gem 'fabrication',      '2.11.3'
  gem 'pry',              '0.10.1'
  gem 'pry-nav',          '0.2.4'
  gem 'rspec-rails',      '2.99'  
end

group :test do
  gem 'capybara',           '2.4.4'
  gem 'capybara-webkit',    '1.3.1'
  gem 'launchy',            '2.4.3'
  gem 'shoulda-matchers',   '2.7.0', require: false
  gem 'database_cleaner',   '1.2.0'
  gem 'selenium-webdriver', '2.44.0'
  gem 'codeclimate-test-reporter', '0.4.5', require: nil
end

group :development, :test, :staging do
  gem 'faker',            '1.4.3'  
end

group :production, :staging do
  gem 'rails_12factor',   '0.0.3'
  gem 'unicorn',          '4.8.3'
  gem 'sentry-raven',     '0.12.2'
end