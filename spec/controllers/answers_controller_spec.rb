require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }

      it 'saves a new answer in the database' do
        expect { subject }.to change(question.answers, :count).by(1)
      end

      it 'adds a answer to the user' do
        expect { subject }.to change(user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'does not save the question' do
        expect { subject }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch :update, params: { id: answer.id, answer: { body: new_body } }, format: :js }

    let!(:answer) { create(:answer, user: user, question: question) }
    let(:body) { answer.body }
    let(:new_body) { 'new body' }

    it 'updates the answer in the database' do
      expect { subject }.to change { answer.reload.body }.from(body).to(new_body)
    end

    context 'with invalid attributes' do
      let(:new_body) { nil }

      it 'does not update the answer' do
        expect { subject }.not_to change { answer.body }
      end
    end

    context 'when the user is not the author' do
      it 'does not update the answer' do
        expect { subject }.not_to change { answer.body }
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: answer.id }, format: :js }

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'should delete answer' do
      expect { subject }.to change(question.answers, :count).by(-1)
    end

    context 'when the user is not the author' do
      let!(:answer) { create(:answer, question: question) }

      it 'should not delete answer' do
        expect { subject }.not_to change(question.answers, :count)
      end
    end

    context 'when best answer' do
      let!(:best_answer_id) { answer.id }

      before do
        answer.mark_as_best
      end

      it 'should delete best answer' do
        expect { subject }.to change { question.reload.best_answer_id }.from(best_answer_id).to(nil)
      end
    end
  end

  describe 'POST #mark_as_best' do
    subject { post :mark_as_best, params: { id: answer.id }, format: :js }

    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    it 'should marks answer as best' do
      expect { subject }.to change { question.reload.best_answer_id }.from(nil).to(answer.id)
    end

    context 'when the user is not the question author' do
      let(:question) { create(:question) }

      it 'should not marks answer as best' do
        expect { subject }.not_to change { question.reload.best_answer_id }
      end
    end
  end
end
