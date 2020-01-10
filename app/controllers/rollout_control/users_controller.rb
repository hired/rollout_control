require_dependency 'rollout_control/application_controller'

module RolloutControl
  class UsersController < ApplicationController
    def create
      if user_identifier
        rollout.activate_user(feature, user_identifier)
        head 204
      else
        head 400
      end
    end

    def destroy
      rollout.deactivate_user(feature, user_identifier)
      head 204
    end

    private

    def feature
      params[:feature_id].to_sym if params[:feature_id]
    end

    def user_identifier
      (params[:user_id] || params[:id]).presence
    end
  end
end
