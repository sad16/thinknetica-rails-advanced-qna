class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    authorize @link

    @link.destroy
  end
end
