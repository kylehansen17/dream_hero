class Story < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chats

  has_one_attached :image
  has_one :story_character
  has_one :character, through: :story_character
  validates :age, presence: true
  def base_instructions
  <<~PROMPT
    You are a master storyteller.

    The listener is #{age} years old.
    The theme is "#{theme}".
    Include a character using the following:
    Name:#{character.name}.
    Occupation: #{character.occupation}.
    Likes: #{character.likes}.

    You are working on a story that is divided into exactly 5 blocks.

    Each block must follow all of these rules:

    1. Block must contain exactly 8 lines
      - Each line must end with a newline
      - No extra blank lines
      - No numbering (no “Block 1”, “1.”, “Line 1”, etc.)
      - Pure story text only
    2. You should also provide exactly three choices (A, B, C)
      - Each choice must be exactly 1 sentence
      - The key names must be exactly:
        - "option_a" for choice A
        - "option_b" for choice B
        - "option_c" for choice C
  PROMPT
  end
end
