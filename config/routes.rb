Rails.application.routes.draw do
  resources :google_play_apps
  resources :itunes_apps
  resources :applists do
    post :scrape_app
  end
  devise_for :users

  root to: "home#index"
end
