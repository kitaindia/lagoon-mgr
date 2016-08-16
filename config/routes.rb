Rails.application.routes.draw do

  root to: "home#index"

  resources :google_play_apps
  resources :itunes_apps
  resources :applists do
    post :scrape_app
    post :done_app
  end
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  resources :users # for Admin
end
