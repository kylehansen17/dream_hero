class CharactersController < ApplicationController
  def create
    @character = Character.new(character_params)
    @character.user = current_user
    if @character.save
      redirect_to new_story_path, notice: "Character was created successfully!"
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_character", partial: "characters/form", locals: { character: @character}) }
      end
    end

  end

  def show
    @character = Character.find(params[:id])
  end

  private

  def character_params
    params.require(:character).permit(:name, :occupation, :likes)
  end
end
