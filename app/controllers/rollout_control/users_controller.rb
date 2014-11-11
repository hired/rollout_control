require_dependency 'rollout_control/application_controller'

module RolloutControl
  class UsersController < ApplicationController
    def create
      if user
        rollout.activate_user(feature, user)
        head 204
      else
        head 400
      end
    end

    def destroy
      rollout.deactivate_user(feature, user)
      head 204
    end

    private

    def feature
      params[:feature_id].to_sym if params[:feature_id]
    end

    def user
      user_param = params[:user_id] || params[:id]
      OpenStruct.new(id: user_param) if user_param
    end
  end
end
