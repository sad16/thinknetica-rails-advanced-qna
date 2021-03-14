require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer) } }

      it 'saves a new answer in the database' do
        expect { subject }.to change(question.answers, :count).by(1)
      end

      it 'adds a answer to the user' do
        expect { subject }.to change(user.answers, :count).by(1)
      end

      it 'redirects to related question show view' do
        is_expected.to redirect_to question
      end
    end

    context 'with invalid attributes' do
      subject { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the question' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 'renders question show view' do
        is_expected.to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: answer.id } }

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'should delete answer' do
      expect { subject }.to change(question.answers, :count).by(-1)
    end

    it 'redirects to question' do
      is_expected.to redirect_to question_path(question)
    end

    context 'when the user is not the author' do
      let!(:answer) { create(:answer, question: question) }

      it 'should not delete answer' do
        expect { subject }.not_to change(question.answers, :count)
      end

      it 'redirects to question' do
        is_expected.to redirect_to question_path(question)
      end
    end
  end

end
