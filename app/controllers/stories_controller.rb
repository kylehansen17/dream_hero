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
    @story.user = current_user
    if @story.save
      redirect_to story_path(@story)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def story_params
    params.require(:story).permit(:name, :theme, :age, :character)
  end
end
