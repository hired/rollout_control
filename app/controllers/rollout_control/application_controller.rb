module RolloutControl
  class ApplicationController < ActionController::Base

    private

    def rollout
      RolloutControl.rollout
    end
  end
end
