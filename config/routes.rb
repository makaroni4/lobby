Rails.application.routes.draw do
  root to: "projects#index"

  resources :projects, only: [:index, :show]
  resources :activities, only: [:new, :create]

  namespace :api do
    resources :activity_logs, only: [] do
      get :open_in_vscode
    end
  end
end
