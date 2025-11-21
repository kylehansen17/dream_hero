require 'ruby_llm/schema'
include RubyLLM::Helpers

class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @story = @chat.story
    @message = @chat.messages.new(message_params.merge(role: "user"))

    if @message.save
      total_messages = @chat.messages.where(role: "assistant").count
      @story_finished = total_messages >= 5
      if @story_finished
    # This is the final turn — finish the story
        prompt = ending_instructions
      else
    # Normal branching story instructions
        prompt = @story.base_instructions
      end
      llm_response = @chat.with_instructions(prompt).with_schema(StoryMessageSchema).ask("The user has selected the following option: #{@message.content}")
      Message.create!(
        role: "assistant",
        content: llm_response.content.to_json,
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

  def ending_instructions
  <<~PROMPT
    You are finishing a bedtime story for a child. You should use the final choice from the user to finish the story.

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
