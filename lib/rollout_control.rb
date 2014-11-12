require "rollout_control/engine"

module RolloutControl
  def self.rollout
    @rollout ||= $rollout
  end

  def self.rollout=(rollout_obj)
    @rollout = rollout_obj
  end

  def self.basic_auth_username
    @basic_auth_username ||= ENV['ROLLOUT_CONTROL_USERNAME']
  end

  def self.basic_auth_username=(username)
    @basic_auth_username = username
  end

  def self.basic_auth_password
    @basic_auth_password ||= ENV['ROLLOUT_CONTROL_PASSWORD']
  end

  def self.basic_auth_password=(password)
    @basic_auth_password = password
  end

  def self.unprotected
    @unprotected ||= false
  end

  def self.unprotected=(flag)
    @unprotected = flag
  end

  def self.configure
    yield self
  end
end
