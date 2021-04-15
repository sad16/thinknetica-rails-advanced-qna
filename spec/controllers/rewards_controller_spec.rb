require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:question) { create(:question, :with_reward, :with_best_answer) }
  let(:answer_author) { question.best_answer.user }
  let(:rewards) { answer_author.rewards }

  describe 'GET #index' do
    before { login(answer_author) }

    before { get :index }

    it 'assigns the requested rewards to @rewards' do
      expect(assigns(:rewards)).to eq(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
