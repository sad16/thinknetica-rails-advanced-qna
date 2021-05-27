require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    subject { post :create, params: { voteable_id: question.id, voteable_type: 'question', value: 1 }, format: :js }

    let(:question) { create(:question) }
    let(:last_vote) { Vote.last }

    it 'should create vote' do
      expect { subject }.to change(Vote, :count).by(1)
      expect(last_vote).to have_attributes(
                             user_id: user.id,
                             voteable_id: question.id,
                             voteable_type: 'Question',
                             value: 1
                           )
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(last_vote.to_json)
    end

    context 'when invalid params' do
      subject { post :create, params: { voteable_id: question.id, voteable_type: 'question' }, format: :js }

      it 'should not create vote' do
        expect { subject }.not_to change(Vote, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq("{\"errors\":[\"Value can't be blank\",\"Value is not included in the list\"]}")
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: vote.id }, format: :js }

    let!(:vote) { create(:vote, user: user) }

    it 'should delete vote' do
      expect { subject }.to change(Vote, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(vote.to_json)
    end

    context 'when the user is not the author' do
      let!(:vote) { create(:vote) }

      it 'should not delete vote' do
        expect { subject }.not_to change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq({ errors: ["You can't delete the vote, because you aren't its author"] }.to_json)
      end
    end
  end
end
