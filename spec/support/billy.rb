Billy.configure do |c|
  c.ignore_cache_port = false
  c.cache = true
  c.cache_request_headers = false
  c.persist_cache = true
  c.cache_path = 'spec/billy'
  c.proxy_port = 51111
  c.ignore_params = ['https://js.stripe.com:443/v2/channel.html']
end

RSpec.configure do |config|
  config.before(:each, billy: true) do
    WebMock.allow_net_connect!
    Capybara.current_driver = :poltergeist_billy
  end

  config.after(:each, billy: true) do
    Capybara.use_default_driver
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end

def billy_whitelist_capybara
  if server = Capybara.current_session.server
    server_url = "#{server.host}:#{server.port}"
    unless Billy.config.whitelist.include?(server_url)
      Billy.configure do |c|
        c.whitelist << server_url
      end
    end
  end
end
