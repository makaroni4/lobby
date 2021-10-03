Rails.application.routes.draw do
  root to: "projects#index"

  resources :projects, only: [:index, :show]
  resources :activities, only: [:index, :new, :create]
end
