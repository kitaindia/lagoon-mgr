class UserApplist < ApplicationRecord
  belongs_to :user
  belongs_to :applist

  scope :reviewing, -> { where(is_done: false) }
  scope :is_done, -> { where(is_done: true) }
end
