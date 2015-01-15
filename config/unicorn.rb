worker_processes 3
timeout 15
preload_app true

before_fork do |server, worker|
  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Sidekiq.configure_client do |config|
    config.redis = { size: 1 }
  end
  Sidekiq.configure_server do |config|
    config.redis = { size: 5 }
  end

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end