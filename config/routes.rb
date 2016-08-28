Rails.application.routes.draw do

  root to: "home#index"

  resources :google_play_apps
  resources :itunes_apps
  resources :applists do
    post :scrape_app
    post :done_app
    collection do
      post :import
      get :empty_csv, format: true, defaults: {format: 'csv'}
    end
  end
  devise_for :users, skip: [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  resources :users # for Admin

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
