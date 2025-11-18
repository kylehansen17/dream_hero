class Story < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chats
  has_one_attached :images
  validates :age, presence: :true
end
