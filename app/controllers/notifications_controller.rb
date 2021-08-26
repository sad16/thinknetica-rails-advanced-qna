class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    question = Question.find(params[:question_id])
    notification = Notification.new(user: current_user, question: question)

    if notification.save
      render json: notification
    else
      render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    notification = Notification.find(params[:id])

    authorize notification

    notification.destroy

    render json: notification
  end
end
