Rails.application.routes.draw do

  mount RolloutControl::Engine => "/rollout"
end
