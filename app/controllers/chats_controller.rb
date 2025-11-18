class ChatsController < ApplicationController
  def create
    @story = Story.find(params[:story_id])

    @chat = Chat.new(title: Chat::DEFAULT_TITLE)
    @chat.story = @story
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render "stories/show"
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def index
    @chat = Chat.all
  end
end
