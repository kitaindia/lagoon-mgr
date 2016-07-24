class Applist < ApplicationRecord
  has_many :user_applists
  has_many :users, through: :user_applists
  has_one :itunes_app
  has_one :google_play_app

  validates :google_play_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates :itunes_url, allow_blank: true, format: /\A#{URI::regexp(%w(http https))}\z/
  validates_with AnyFieldFillValidator, fields: [:google_play_url, :itunes_url]
end
