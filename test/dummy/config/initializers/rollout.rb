require 'fakeredis'
require 'rollout'

$redis = Redis.new
RolloutControl.configure do |rc|
  rc.rollout = Rollout.new(Redis.new)
  rc.unprotected = true
end
