require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should have_one(:question_with_best_answer).class_name('Question').with_foreign_key('best_answer_id').dependent(:nullify) }

  it { should validate_presence_of(:body) }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'best answer' do
    let(:answer) { create(:answer) }
    let(:question) { answer.question }

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
end
