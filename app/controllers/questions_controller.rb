class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :find_question, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    @vote = current_user&.vote_by(@question) || @question.votes.new
    set_gon
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
    if @question.update(question_params)
      flash_notice("The question has been successfully updated")
    else
      flash_notice("The question has not been updated")
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: "The question has been successfully deleted"
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:name, :image])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def authorize_user!
    authorize @question
  end

  def set_gon
    gon.question_id = @question.id
    gon.current_user_id = current_user&.id
  end

  def publish_question
    return if @question.errors.present?

    ActionCable.server.broadcast(
      'questions',
      {
        template: render_template(
          partial: 'websockets/questions/list_item',
          locals: { question: @question }
        )
      }
    )
  end
end

