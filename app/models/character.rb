class Character < ApplicationRecord
  belongs_to :user
  has_many :story_characters
  has_many :stories, through: :story_characters
  validates :name, :occupation, :likes, presence: :true
end
