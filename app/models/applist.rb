class Applist < ApplicationRecord
  has_many :user_applists
  has_many :users, through: :user_applists
  has_many :itunes_apps
  has_many :google_play_apps

  validates :google_play_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates :itunes_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates_with AnyFieldFillValidator, fields: [:google_play_url, :itunes_url]
end
