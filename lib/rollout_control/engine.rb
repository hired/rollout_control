module RolloutControl
  class Engine < ::Rails::Engine
    isolate_namespace RolloutControl

    initializer 'Basic Auth' do |app|
      unless RolloutControl.unprotected
        app.config.middleware.use Rack::Auth::Basic do |username, password|
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
