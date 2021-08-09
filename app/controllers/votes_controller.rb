class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_voteable, only: :create

  def create
    vote = @voteable.votes.new(user: current_user, value: params[:value])

    if vote.save
      render json: vote
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    vote = Vote.find(params[:id])

    authorize vote

    vote.destroy
    render json: vote
  end

  private

  def set_voteable
    @voteable = voteable_type.classify.constantize.find(params[:voteable_id])
  end

  def voteable_type
    params[:voteable_type]
  end
end
