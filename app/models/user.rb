class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_applists
  has_many :applists, through: :user_applists do
    def reviewing
      where("user_applists.is_done = ?", false)
    end

    def is_done
      where("user_applists.is_done = ?", true)
    end
  end

  validates_uniqueness_of :username
  validates_presence_of :username
end
