class User < ApplicationRecord
  has_many :stories
  has_many :characters
  has_many :chats, through: :stories
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
