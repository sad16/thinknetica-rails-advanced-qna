require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  let(:user) { create(:user) }

  describe '#author_of?' do
    let(:resource) { double user_id: user_id }
    let(:user_id) { user.id }

    it { expect(user).to be_author_of(resource) }

    context 'when the user is not the author' do
      let(:second_user) { create(:user) }
      let(:user_id) { second_user.id }

      it { expect(user).not_to be_author_of(resource) }
    end
  end

  describe '#best_answers' do
    let!(:answer) { create(:answer, :best, user: user) }

    it { expect(user.best_answers).to eq([answer]) }
  end

  describe '#rewards' do
    let(:question) { create(:question, :with_reward, :with_best_answer) }
    let(:user) { question.best_answer.user }

    it { expect(user.rewards).to eq([question.reward]) }
  end

end
