# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'fakeredis'
require 'rollout'
require 'pry'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

$redis = Redis.new
$rollout = Rollout.new($redis)

class ActiveSupport::TestCase
  setup do
    $redis.flushdb
  end

  private

  def last_json
    JSON.parse(response.body)
  end
end
