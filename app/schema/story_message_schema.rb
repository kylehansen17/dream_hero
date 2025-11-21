class StoryMessageSchema < RubyLLM::Schema
  string :story, description: <<~TXT
    This is a story block that continues the story.

    Each block must follow all of these rules:

    1. The story block must contain exactly 8 lines
      - Each line must end with a newline
      - No extra blank lines
      - No numbering (no “Block 1”, “1.”, “Line 1”, etc.)
      - Pure story text only
    TXT

  string :option_a, description: "This is one of thee options the user can pick to make the story progress. Should be a sentence describing the action or choice the user wants to make"
  string :option_b, description: "SThis is one of thee options the user can pick to make the story progress. Should be a sentence describing the action or choice the user wants to make"
  string :option_c, description: "This is one of thee options the user can pick to make the story progress. Should be a sentence describing the action or choice the user wants to make"
end
