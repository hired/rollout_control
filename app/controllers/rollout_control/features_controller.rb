require_dependency 'rollout_control/application_controller'

module RolloutControl
  class FeaturesController < ApplicationController
    def index
      render json: rollout.features.to_json
    end

    def show
      render json: rollout.get(feature)
    end

    def update
      rollout.activate_percentage(feature, params[:percentage]) if params[:percentage]
      head 204
    end

    private

    def feature
      params[:id].to_sym if params[:id]
    end
  end
end
