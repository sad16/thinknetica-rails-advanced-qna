class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :mark_as_best]

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
    if current_user.author_of?(@answer.question)
      @answer.mark_as_best
    else
      flash_alert("You can't mark the answer, because you aren't author the question")
    end
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
end
