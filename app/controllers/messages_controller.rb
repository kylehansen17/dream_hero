class MessagesController < ApplicationController
    def create
    @chat = current_user.chats.find(params[:chat_id])
    @story = @chat.story
    @message = @chat.messages.new(message_params.merge(role: "user"))

    if @message.save
      total_messages = @chat.messages.where(role: "user").count
      @story_finished = total_messages >= 5
        if @story_finished
      # This is the final turn — finish the story
          prompt = ending_instructions
        else
      # Normal branching story instructions
          prompt = instructions
        end
        llm_response = @chat.with_instructions(prompt).ask(@message.content)
          Message.create!(
      role: "assistant",
      content: llm_response.content,
      chat: @chat
    )
      respond_to do |format|
      format.html { redirect_to chat_path(@chat) }
      format.turbo_stream { render 'create' }
    end
    else
      render "chat/show", status: :unprocessable_entity
    end
    end

  private

  # def instructions
  #   prompt = "You are a master storyteller and know many bedtime stories that make kids happy and help them go to sleep and have good dreams. I am a child that is #{@story.age} years old that wants to go to sleep. The theme is #{@story.theme}. Make up the characters on your own.\n\nTell me a good bedtime story in 5 blocks, where I can choose my own adventure at key points in between each story block. Each block should be 5 lines. Stop the story at these key points and present me with three branching paths. Provide the following content in markdown: story_content as a string that contains the current story information, path_a which is a string for the first path, path_b which is a string for the second path, path_c which is a string for the third path."

  #   # story_context = "Here is the context of the story: #{@story.content}."
  #   [prompt, @story.system_prompt].compact.join("\n\n")
  # end

  def instructions
  story_context = <<~TXT
    STORY CONTEXT:
    - Age: #{@story.age}
    - Theme: #{@story.theme}
    - Character: #{@story.character}
  TXT

  base_prompt = <<~PROMPT
    You are a master storyteller who creates bedtime stories for children.
    The listener is #{@story.age} years old.
    The theme is #{@story.theme}.

    Continue the #{@story} that is divided into exactly 5 blocks.

    Each block must follow all of these rules:

    1. Story must contain exactly 8 lines
      - Each line must end with a newline
      - No extra blank lines
      - No numbering (no “Block 1”, “1.”, “Line 1”, etc.)
      - Pure story text only
    2. After the 8 lines, provide exactly three choices (A, B, C)
      - Each choice must be exactly 1 sentence
      - The key names must be exactly:
        - "a" for choice A
        - "b" for choice B
        - "c" for choice C
    3. The entire output for each block MUST BE JSON FORMAT, VALID JSON ONLY, JSON with the following structure:
      {
        "story": "8 lines of story content here\nline 2\nline 3\nline 4\nline 5\nline 6\nline 7\nline 8",
        "a": "Sentence describing option A.",
        "b": "Sentence describing option B.",
        "c": "Sentence describing option C."
      }
  PROMPT

  "#{story_context}\n#{base_prompt}"
  end

  def ending_instructions
  <<~PROMPT
    You are finishing a bedtime story for a child.

    The story must end here.
    Do **not** provide branching paths.
    Do **not** ask questions.
    Write a warm, satisfying ending in 10–15 lines.
    Close the narrative completely.

    Output only the final story text in Markdown.
  PROMPT
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
