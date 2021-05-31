require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should have_one(:question_with_best_answer).class_name('Question').with_foreign_key('best_answer_id').dependent(:nullify) }
  it { should have_one(:reward).through(:question_with_best_answer) }

  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of(:body) }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '.bests scope' do
    subject { described_class.bests }

    let!(:answer) { create(:answer) }
    let!(:best) { create(:answer, :best) }

    it { is_expected.to eq([best]) }
  end

  describe 'best answer' do
    let(:question) { create(:question, :with_answer) }
    let(:answer) { question.answers.first }

    describe '#mark_as_best' do
      subject { answer.mark_as_best }

      it do
        expect { subject }.to change { question.reload.best_answer_id }.from(nil).to(answer.id)
      end
    end

    describe '#best?' do
      it { expect(answer).not_to be_best }

      context 'when best' do
        let(:answer) { create(:answer, :best) }

        it { expect(answer).to be_best }
      end
    end
  end

  describe '#assign_reward' do
    subject { answer.assign_reward }

    let(:question) { create(:question_with_reward_and_answer) }
    let(:reward) { question.reward }
    let(:answer) { question.answers.first }

    context 'when set best answer' do
      before do
        question.update(best_answer: answer)
      end

      it do
        expect { subject }.to change { reward.reload.user_id }.from(nil).to(answer.user_id)
      end

      context 'when question without reward' do
        let(:question) { create(:question, :with_answer) }

        it do
          expect { subject }.not_to raise_error
        end
      end
    end

    context 'when question without best answer' do
      it do
        expect { subject }.not_to change { reward.reload.user_id }
      end
    end
  end

  describe '#unassign_reward' do
    subject { answer.unassign_reward }

    let(:question) { create(:question_with_reward_and_best_answer_answer) }
    let(:reward) { question.reward }
    let(:answer) { question.best_answer }

    it do
      expect { subject }.to change { reward.reload.user_id }.from(answer.user_id).to(nil)
    end

    context 'without reward' do
      it do
        expect { subject }.not_to raise_error
      end
    end

    context 'when callback before destroy' do
      subject { answer.destroy }

      it do
        expect(answer).to receive(:unassign_reward)
        is_expected
      end
    end
  end
end
