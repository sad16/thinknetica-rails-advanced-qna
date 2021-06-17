class ApplicationController < ActionController::Base
  include ApplicationHelper

  private

  def render_template(options)
    ApplicationController.render(options)
  end
end
