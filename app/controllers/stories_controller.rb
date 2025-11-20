require 'ruby_llm/schema'
include RubyLLM::Helpers

class StoriesController < ApplicationController

  def index
    @stories = Story.all
    @front_story = Story.last
    @feature_stories = Story.where.not(id: @front_story.id)
    @character = Character.new
    @characters = Character.all
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

  def instructions(story)
  <<~PROMPT
    You are a master storyteller.

    The listener is #{story.age} years old.
    The theme is "#{story.theme}".
    Include a character using the following:
    Name:#{story.character.name}.
    Occupation: #{story.character.occupation}.
    Likes: #{story.character.likes}.

    Create a bedtime story that is divided into exactly 5 blocks.

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
    3. The entire output for each block MUST BE JSON FORMAT, VALID JSON ONLY, no exceptions, with the following structure:
      {
        "story": "8 lines of story content here\nline 2\nline 3\nline 4\nline 5\nline 6\nline 7\nline 8",
        "a": "Sentence describing option A.",
        "b": "Sentence describing option B.",
        "c": "Sentence describing option C."
      }

    person_schema = schema "PersonData", description: "A person object" do
  string :name, description: "Person's full name"
  number :age
  boolean :active, required: false

  object :address do
    string :street
    string :city
  end

  array :tags, of: :string
end

puts person_schema.to_json
  PROMPT
  end
end
