ENV['RAILS_ENV'] = 'test'

# RolloutControl config is done in test/dummy/config/initializers/rollout.rb
require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'
require 'fakeredis'
require 'rollout'
require 'pry'

Rails.backtrace_cleaner.remove_silencers!

class ActiveSupport::TestCase
  setup do
    $redis.flushdb
  end

  private

  def last_json
    JSON.parse(response.body)
  end
end
