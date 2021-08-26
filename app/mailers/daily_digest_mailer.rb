class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions_data = Services::DailyDigestData.new.call
    mail to: user.email
  end
end
