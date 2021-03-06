source "https://rubygems.org"
ruby "2.3.6"

gem "rails",                "4.1.8"
gem "pg",                   "0.18.1"
gem "haml-rails",           "0.5.3"
gem "bootstrap-sass",       "3.3.1.0"
gem "bootstrap_form",       "2.2.0"
gem "autoprefixer-rails",   "4.0.1.1"
gem "sass-rails",           "4.0.5"
gem "font-awesome-rails",   "4.3.0.0"
gem "uglifier",             "2.7.0"
gem "coffee-rails",         "4.0.1"
gem "jquery-rails",         "3.1.2"
gem "turbolinks",           "2.5.3"
gem "jquery-turbolinks",    "2.1.0"
gem "jbuilder",             "2.2.6"
gem "sidekiq",              "3.3.0"
gem "figaro",               "1.0.0"
gem "omniauth-github",      "1.1.2"
gem "bcrypt",               "3.1.9"
gem "nokogiri",             "1.6.5"
gem "parsley-rails",        "2.0.7.0"
gem "redcarpet",            "3.2.2"
gem "pygments.rb",          "0.6.0"
gem "stripe",               "1.16.1"
gem "wicked_pdf",           "0.11.0"
gem "mini_magick",          "4.1.0"
gem "carrierwave",          "0.10.0"
gem "carrierwave-aws",      "0.5.0"

group :development do
  gem "thin",               "1.6.3"
  gem "hirb",               "0.7.2"
  gem "quiet_assets",       "1.0.3"
  gem "letter_opener",      "1.3.0"
end

group :development, :test do
  gem "fabrication",        "2.11.3"
  gem "pry",                "0.10.1"
  gem "pry-nav",            "0.2.4"
  gem "rspec-rails",        "3.6.0"
  gem "wkhtmltopdf-binary", "0.12.3.1"
  gem "pry-rescue",         "1.4.1"
  gem "pry-stack_explorer", "0.4.9.2"
end

group :test do
  gem "capybara",            "2.15.1"
  gem "capybara-email",      "2.4.0"
  gem "launchy",             "2.4.3"
  gem "shoulda-matchers",    "2.8.0", require: false
  gem "database_cleaner",    "1.2.0"
  gem "selenium-webdriver",  "3.6.0"
  gem "vcr",                 "2.9.3"
  gem "webmock",             "1.20.4"
  gem "poltergeist",         "1.6.0"
  gem "rack_session_access", "0.1.1"
  gem "codeclimate-test-reporter", "0.4.5", require: nil
  gem "rspec_junit_formatter"
end

group :development, :test, :staging do
  gem "faker",              "1.4.3"
end

group :production, :staging do
  gem "rails_12factor",     "0.0.3"
  gem "unicorn",            "4.8.3"
  gem "sentry-raven",       "0.12.2"
end
