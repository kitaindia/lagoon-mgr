Rails.application.routes.draw do
  resources :google_play_apps
  resources :itunes_apps
  resources :applists
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
