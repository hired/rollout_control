RolloutControl::Engine.routes.draw do
  resources :features, only: [:index, :show, :update] do
    resources :groups, only: [:index, :create, :destroy]
    resources :users, only: [:index, :create, :destroy]
  end
end
