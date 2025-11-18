class MessagesController < ApplicationController
SYSTEM_PROMPT = "You are a master storyteller and know many bedtime stories that make kids happy and help them go to sleep and have good dreams. I am a child that is #{story.age} years old that wants to go to sleep. The theme is #{story.theme}. Make up the characters on your own.\n\nTell me a good bedtime story in 5 blocks, where I can choose my own adventure at key points in between each story block. Each block should be 5 lines. Stop the story at these key points and present me with three branching paths. Provide a JSON with the following content: story_content as a string that contains the current story information, path_a which is a string for the first path, path_b which is a string for the second path, path_c which is a string for the third path."
def create
  @chat = current_user.chats.find(params[:chat_id])
  @story = @chat.story
  @Message Scheduler = Message.new(message_params)
  @Message Scheduler.chat = @chat
  @Message Scheduler.role = "user"
  if @Message Scheduler.save
    ruby_llm_chat = RubyLLM.chat
    response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
    Message.create(role: "assistant", content: response.content, chat: @chat)
    redirect_to chat_messages_path(@chat)
  else
    render "chat/show", status: :unprocessable_entity
  end
end
private
def instructions
  story_context = "Here is the context of the story: #{story.content}."
  [SYSTEM_PROMPT, story_context, @story.system_prompt].compact.join("\n\n")
end
def message_params
  params.require(:message).permit(:content)
end
end
