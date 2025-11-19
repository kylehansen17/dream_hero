class Message < ApplicationRecord
  belongs_to :chat
  acts_as_message
end
