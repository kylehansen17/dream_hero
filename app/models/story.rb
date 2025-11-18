class Story < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chats
  has_one :story_character
  has_one :character, through: :story_character
  validates :age, presence: :true
end
