require_dependency 'rollout_control/application_controller'

module RolloutControl
  class GroupsController < ApplicationController
    def create
      if group
        rollout.activate_group(feature, group)
        head 204
      else
        head 400
      end
    end

    def destroy
      rollout.deactivate_group(feature, group)
      head 204
    end

    private

    def feature
      params[:feature_id].to_sym if params[:feature_id]
    end

    def group
      group_param = params[:group].presence || params[:id]
      group_param.to_sym if group_param
    end
  end
end
