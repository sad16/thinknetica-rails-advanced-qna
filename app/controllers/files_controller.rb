class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    authorize @file, policy_class: FilePolicy

    @file.purge
  end
end
