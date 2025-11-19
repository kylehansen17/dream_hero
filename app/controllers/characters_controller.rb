class CharactersController < ApplicationController
  def create
    @character = Character.new(character_params)
    @character.user = current_user
    if @character.save
      html_content = "<p>Character was created successfully!</p>".html_safe
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_character", html: html_content) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("new_character", partial: "characters/form", locals: { character: @character}) }
      end
    end
  end

  private

  def character_params
    params.require(:character).permit(:name, :occupation, :likes)
  end
end
