class Chat < ApplicationRecord
  belongs_to :story
  has_many :messages, dependent: :destroy
  acts_as_chat
end
