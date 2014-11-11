module RolloutControl
  class ApplicationController < ActionController::Base

    private

    def rollout
      $rollout
    end
  end
end
