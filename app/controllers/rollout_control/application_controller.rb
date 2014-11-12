module RolloutControl
  class ApplicationController < ActionController::Base
    before_filter :authenticate

    private

    def rollout
      RolloutControl.rollout
    end

    def authenticate
      unless RolloutControl.unprotected
        authenticate_or_request_with_http_basic('Rollout Control') do |username, password|
          rc_username, rc_password = RolloutControl.basic_auth_username, RolloutControl.basic_auth_password
          if rc_username.present? && rc_password.present?
            username == rc_username && password == rc_password
          else
            false
          end
        end
      end
    end
  end
end
