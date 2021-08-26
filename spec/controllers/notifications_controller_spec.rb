require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    subject { post :create, params: { question_id: question.id }, format: :json }

    let!(:question) { create(:question) }
    let(:notification) { Notification.last }

    it 'should create notification' do
      expect { subject }.to change(Notification, :count).by(1)
      expect(notification).to have_attributes(
                                user_id: user.id,
                                question_id: question.id,
                              )
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(serialize(notification).to_json)
    end

    context 'when notification alredy exist' do
      let!(:notification) { create(:notification, user: user, question: question) }

      it 'should not create notification' do
        expect { subject }.not_to change(Notification, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ errors: ["User has already been taken"] }.to_json)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: notification.id }, format: :json }

    let!(:notification) { create(:notification, user: user) }

    it 'should delete notification' do
      expect { subject }.to change(Notification, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(serialize(notification).to_json)
    end

    context 'when the user is not the owner' do
      let!(:notification) { create(:notification) }

      it 'should not delete vote' do
        expect { subject }.not_to change(Vote, :count)
        expect(response).to have_http_status(:forbidden)
        expect(response.body).to eq({ errors: ["You are not authorized to perform this action."] }.to_json)
      end
    end
  end
end
