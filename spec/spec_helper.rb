ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'capybara/rails'

Capybara.server_port = 52662
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # ## Mock Framework
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.infer_spec_type_from_file_location!
end