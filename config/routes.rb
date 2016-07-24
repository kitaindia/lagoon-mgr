Rails.application.routes.draw do

  root to: "home#index"

  resources :google_play_apps
  resources :itunes_apps
  resources :applists do
    post :scrape_app
    post :done_app
  end
  devise_for :users

end
