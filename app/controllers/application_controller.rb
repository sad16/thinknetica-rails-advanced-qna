class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    message = "You are not authorized to perform this action."

    respond_to do |format|
      format.json do
        render json: { errors: [message] }, status: :forbidden
      end
      format.html do
        flash[:alert] = message
        redirect_to(request.referrer || root_path)
      end
      format.all do
        head :forbidden
      end
    end
  end

  def render_template(options)
    ApplicationController.render(options)
  end
end
