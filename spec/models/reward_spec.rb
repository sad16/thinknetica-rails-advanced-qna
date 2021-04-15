require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }

  it { should validate_presence_of(:name) }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe 'instance methods' do
    describe '#assign' do
      subject { reward.assign }

      let(:question) { create(:question_with_reward_and_answer) }
      let(:reward) { question.reward }
      let(:answer) { question.answers.first }

      before do
        question.update(best_answer: answer)
      end

      it do
        expect { subject }.to change { reward.reload.user_id }.from(nil).to(answer.user_id)
      end

      context 'when question without best answer' do
        let(:question) { create(:question, :with_reward) }

        it do
          expect { subject }.not_to change { reward.reload.user_id }
        end
      end
    end

    describe '#unassign' do
      subject { reward.unassign }

      let(:reward) { create(:reward, :assigned) }
      let(:user) { reward.user }

      it do
        expect { subject }.to change { reward.reload.user_id }.from(user.id).to(nil)
      end
    end
  end
end
