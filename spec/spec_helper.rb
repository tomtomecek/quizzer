require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'capybara/rails'
require 'capybara/email/rspec'
require 'capybara/poltergeist'
require 'vcr'
require 'rack_session_access/capybara'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
  c.ignore_hosts 'codeclimate.com'
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    inspector: './chrome.sh',
    js_errors: true
  )
end
Capybara.javascript_driver = :poltergeist

Capybara.server_port = 52662
Capybara.default_wait_time = 5

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
  config.filter_run_excluding :no_travis if ENV["NO_TRAVIS"]
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.order = "random"

  config.include(ExpectationMacros)
  config.include(AuthenticationMacros)
  config.include(QuizManagementMacros)
  config.include(ModalMacros)
end
