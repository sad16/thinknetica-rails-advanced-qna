class SearchController < ApplicationController
  before_action :authenticate_user!

  rescue_from Services::Search::Base::EmptySearchError, with: :empty_search_error

  def global
    respond_to do |format|
      format.html
      format.json { render json: Services::Search::Global.new.call(search_params).to_a, each_serializer: Search::GlobalSerializer, adapter: :attributes }
    end
  end

  def questions
    respond_to do |format|
      format.html
      format.json { render_json(Services::Search::Questions.new.call(search_params)) }
    end
  end

  def answers
    respond_to do |format|
      format.html
      format.json { render_json(Services::Search::Answers.new.call(search_params)) }
    end
  end

  def comments
    respond_to do |format|
      format.html
      format.json { render_json(Services::Search::Comments.new.call(search_params)) }
    end
  end

  def users
    respond_to do |format|
      format.html
      format.json { render_json(Services::Search::Users.new.call(search_params)) }
    end
  end

  private

  def search_params
    params.require(:search).permit!
  end

  def empty_search_error
    render json: { errors: ['Error: search without params'] }, status: :unprocessable_entity
  end

  def render_json(data)
    render json: { data: data }
  end
end
