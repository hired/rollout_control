require 'fakeredis'
require 'rollout'

$redis = Redis.new
RolloutControl.configure do |rc|
  rc.rollout = Rollout.new(Redis.new, id_user_by: :rollout_identifier)
  rc.unprotected = true
end
