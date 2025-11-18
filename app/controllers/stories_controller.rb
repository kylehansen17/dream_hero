class StoriesController < ApplicationController
  def index
    @stories = Story.all
    @front_story = Story.last
    @feature_stories = Story.where.not(id: @front_story.id)
  end
  def show
    @story = Story.find(params[:id])
  end

end
