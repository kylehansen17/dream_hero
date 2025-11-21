require 'ruby_llm/schema'
include RubyLLM::Helpers

class StoriesController < ApplicationController

  def index
    @stories = Story.all
    @front_story = Story.last
    @feature_stories = Story.where.not(id: @front_story.id)
    @character = Character.new
    @characters = current_user.characters.all
  end

  def show
  @story = current_user.stories.find(params[:id])

  # Get the first (or last) chat
  @chat = @story.chats.first

  # All messages from that chat
  @messages = @chat&.messages || []

  # Only assistant messages
  @assistant_messages = @messages.select { |m| m.role == "assistant" }

  # Example: get the last assistant message
  @last_assistant_message = @assistant_messages.last&.content
  if @last_assistant_message.present?
    system_prompt = summarize(@last_assistant_message)

  # Create a chat client with system instructions
    client = RubyLLM.chat.with_instructions([
      { role: "system", content: system_prompt, temperature: 0.9 }
    ])

  # Ask the LLM to generate the summary
    summary_response = client.ask("Summarize the story")
    @summary = summary_response.content
  else
    @summary = "No story content yet."
  end
  end

  def new
    @story = Story.new
    character_id = params[:character_id]
    if character_id.present?
      character = Character.find_by(id: character_id)
      @story.character = character if character.present?
      @character = Character.new
    else
      @character = Character.new
    end
  end

  def create
    @story = Story.new(story_params.slice(:name, :theme, :age))
    @story.character = Character.find(story_params[:character])
    # @story.system_prompt = { age: @story.age, theme: @story.theme, character: @story.character}
    @story.user = current_user
    if @story.save
      chat = @story.chats.create!
      system_prompt = @story.base_instructions
      client = RubyLLM.chat.with_instructions([
      { role: "system", content: system_prompt, temperature: 0.9 }
    ])

    llm_response = client.with_schema(StoryMessageSchema).ask("Start the story by writing the first story block.")
      assistant_message = llm_response.content.to_json

    chat.messages.create!(
      role: "assistant",
      content: assistant_message
    )
    summary_prompt = summarize(assistant_message)
    summary_client = RubyLLM.chat.with_instructions([
      { role: "system", content: summary_prompt, temperature: 0.7 }
    ])
    summary_response = summary_client.ask("Summarize the story")
    @story.update(summary: summary_response.content)

    title_client = RubyLLM.chat
    title_response = title_client.ask("Generate a story title from the following summary #{@story.summary}")
    @story.update(name: title_response.content)

  # Generate the image
# image = RubyLLM.paint(
#   "Illustration for the story titled #{@story.name} about #{@story.theme} featuring #{@story.character.name}, in an engaging style suitable for ages #{@story.age}.",
#   model: "imagen-4.0-generate-preview-06-06"
# )
# filename = "#{@story.name.parameterize}-illustration.png"
# image_io = StringIO.new(image.to_blob)

#     @story.image.attach(
#     io: image_io,
#     filename: filename,
#     content_type: image.mime_type || 'image/png' # Use detected MIME type or default
#   )

    GenerateStoryImageJob.perform_later(@story.id)

   redirect_to chat_path(chat)
    else
      render :new, status: :unprocessable_entity
    end
  end
  def continue
  # Find the story first
  story = current_user.stories.find(params[:id])

  # Get the first chat (or the chat you created)
  chat = story.chats.first # or .last if you prefer

  redirect_to chat_path(chat)
  end

  def summarize(long_story)
    <<~PROMPT
    You are a magazine article writer.
    Summarize the story from #{long_story} in no more than 5 lines.
  PROMPT
  end

  private

  def story_params
    params.require(:story).permit(:name, :theme, :age, :character)
  end
end
