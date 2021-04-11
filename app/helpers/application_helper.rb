module ApplicationHelper
  def flash_notice(message)
    flash[:notice] = message
  end

  def flash_alert(message)
    flash[:alert] = message
  end
end
