class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_applists
  has_many :applists, through: :user_applists

  validates_uniqueness_of :username
  validates_presence_of :username
end
