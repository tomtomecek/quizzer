source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails',              '4.1.8'
gem 'pg',                 '0.18.1'
gem 'haml-rails',         '0.5.3'
gem 'bootstrap-sass',     '3.3.1.0'
gem 'autoprefixer-rails', '4.0.1.1'
gem 'sass-rails',         '~> 4.0.3'
gem 'uglifier',           '>= 1.3.0'
gem 'coffee-rails',       '~> 4.0.0'
gem 'jquery-rails',       '3.1.2'
gem 'turbolinks',         '2.5.3'
gem 'jbuilder',           '~> 2.0'
gem 'paratrooper',        '2.4.1'
gem 'sidekiq',            '3.3.0'
gem 'figaro',             '1.0.0'

group :development do
  gem 'thin',             '1.6.3'
  gem 'hirb',             '0.7.2'
  gem 'quiet_assets',     '1.0.3'
  gem 'letter_opener',    '1.3.0'
end

group :development, :test do
  gem 'faker',            '1.4.3'
  gem 'fabrication',      '2.11.3'
  gem 'pry',              '0.10.1'
  gem 'pry-nav',          '0.2.4'
  gem 'rspec-rails',      '2.99'  
end

group :test do
  gem 'capybara',         '2.4.4'
  gem 'launchy',          '2.4.3'
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner', '1.2.0'
end

group :production, :staging do
  gem 'rails_12factor',   '0.0.3'
  gem 'unicorn',          '4.8.3'
  gem 'sentry-raven',     '0.12.2'
end