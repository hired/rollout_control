require_dependency 'rollout_control/application_controller'

module RolloutControl
  class FeaturesController < ApplicationController
    def index
      features = rollout.features.map do |feature|
        rollout.get(feature).to_hash.merge(name: feature)
      end
      render json: features.to_json
    end

    def show
      render json: rollout.get(feature).to_hash.merge(name: feature)
    end

    def update
      rollout.set_feature_data(feature, data_params) if params[:data]

      if params[:percentage]
        rollout.activate_percentage(feature, params[:percentage])
      end

      head 204
    end

    def destroy
      rollout.delete(feature)
      head 204
    end

    private

    def feature
      params[:id].to_sym
    end

    def data_params
      params.permit(data: {})[:data].to_h
    end
  end
end
