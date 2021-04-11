class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    if current_user.author_of?(@link.linkable)
      @link.destroy
    else
      flash_alert("You can't delete the link, because you aren't its author")
    end
  end
end
