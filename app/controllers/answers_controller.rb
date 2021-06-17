class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :mark_as_best]

  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash_notice("The answer has been successfully created")
    else
      flash_alert("The answer has not been created")
    end
  end

  def update
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        flash_notice("The answer has been successfully updated")
      end
    else
      flash_alert("You can't update the answer, because you aren't its author")
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash_notice("The answer has been successfully deleted")
    else
      flash_alert("You can't delete the answer, because you aren't its author")
    end
  end

  def mark_as_best
    Answers::MarkAsBestService.new.call(current_user, @answer)
  rescue Answers::MarkAsBestService::UserNotAuthorError
    flash_alert("You can't mark the answer, because you aren't author the question")
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.present?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      {
        id: @answer.id,
        author_id: @answer.user_id,
        templates: {
          answer: render_template(
            partial: 'websockets/answers/answer',
            locals: { answer: @answer }
          ),
          vote_links: render_template(
            partial: 'websockets/shared/votes/vote_links',
            locals: { voteable: @answer, vote: @answer.votes.new }
          )
        }
      }
    )
  end
end
