class StoriesController < ApplicationController

  def index
    @stories = Story.all
    @front_story = Story.last
    @feature_stories = Story.where.not(id: @front_story.id)
    @character = Character.new
  end

  def show
    @story = Story.find(params[:id])
    @response = @story.messages.where(role: "assistant")
    @message = @response.first.content
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params.slice(:name, :theme, :age))
    @story.character = Character.find(story_params[:character])
    # @story.system_prompt = { age: @story.age, theme: @story.theme, character: @story.character}
    @story.user = current_user
    if @story.save
      chat = @story.chats.create!
      system_prompt = instructions(@story)
      client = RubyLLM.chat.with_instructions([
      { role: "system", content: system_prompt, temperature: 0.9 }
    ])

    llm_response = client.ask("Start the story.")
      assistant_message = llm_response.content
      chat.messages.create!(
      role: "assistant",
      content: assistant_message
    )
      redirect_to chat_path(chat)
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def story_params
    params.require(:story).permit(:name, :theme, :age, :character)
  end

  def instructions(story)
  <<~PROMPT
    You are a master storyteller.

    The listener is #{story.age} years old.
    The theme is "#{story.theme}".
    Include a character using the following:
    Name:#{story.character.name}.
    Occupation: #{story.character.occupation}.
    Likes: #{story.character.likes}.

    Create a bedtime story in **5 blocks**, each block exactly 15 lines.
    After each block, stop and provide **three choices**:
    - path_a
    - path_b
    - path_c

    Output in Markdown with:
    - story_content
    - path_a
    - path_b
    - path_c
  PROMPT
  end
end
