class Applist < ApplicationRecord
  has_many :user_applists
  has_many :users, through: :user_applists
  has_many :itunes_apps
  has_many :google_play_apps
end
