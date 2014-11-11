RolloutControl::Engine.routes.draw do
  resources :features, only: [:index, :show, :update] do
    member do
      put :activate
      put :deactivate
    end

    resources :groups, only: [:index, :create, :destroy]
    resources :users, only: [:index, :create, :destroy]
  end
end
