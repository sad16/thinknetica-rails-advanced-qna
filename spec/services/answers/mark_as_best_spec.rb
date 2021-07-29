require 'rails_helper'

RSpec.describe Services::Answers::MarkAsBest, type: :service do
  subject { described_class.new.call(user, answer) }

  let(:question) { create(:question_with_reward_and_answer) }
  let(:user) { question.user }
  let(:answer) { question.answers.first }
  let(:reward) { question.reward }

  describe '#call' do
    it do
      expect { subject }.to change { question.reload.best_answer_id }.from(nil).to(answer.id)
    end

    it do
      expect { subject }.to change { reward.reload.user_id }.from(nil).to(answer.user_id)
    end

    context "when user is not question's author" do
      let(:user) { create(:user) }

      it do
        expect { subject }.to raise_error(described_class::UserNotAuthorError)
      end
    end
  end
end
