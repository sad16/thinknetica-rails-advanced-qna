class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :find_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    @vote = current_user&.vote_by(@question) || @question.votes.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: "The question has been successfully created"
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash_notice("The question has been successfully updated")
      end
    else
      flash_alert("You can't update the question, because you aren't its author")
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: "The question has been successfully deleted"
    else
      redirect_to @question, alert: "You can't delete the question, because you aren't its author"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:name, :image])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
