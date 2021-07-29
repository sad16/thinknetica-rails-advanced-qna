require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  describe 'GET #enter_email' do
    subject { get :enter_email, params: { enter_email_token: enter_email_token } }

    let!(:auth) { create(:authorization, :with_enter_email_token) }
    let(:enter_email_token) { auth.enter_email_token }

    let(:service) { double('Services::Authorizations::CheckEnterEmail') }

    it do
      expect(Services::Authorizations::CheckEnterEmail).to receive(:new).and_return(service)
      expect(service).to receive(:call).with(auth)
      subject
      expect(response).to render_template :enter_email
    end

    context 'when token expired' do
      before do
        allow(service).to receive(:call).with(auth).and_raise(Services::Authorizations::CheckEnterEmail::ExpiredError)
      end

      it do
        expect(Services::Authorizations::CheckEnterEmail).to receive(:new).and_return(service)
        expect(service).to receive(:call).with(auth)
        is_expected.to redirect_to root_path
      end
    end

    context 'when auth not found' do
      let(:enter_email_token) { 'not_found_token' }

      it do
        expect(Services::Authorizations::CheckEnterEmail).not_to receive(:new)
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #update_email' do
    subject { post :update_email, params: { enter_email_token: enter_email_token, email: email } }

    let!(:auth) { create(:authorization, :with_enter_email_token) }
    let(:enter_email_token) { auth.enter_email_token }
    let(:email) { 'test@test.com' }

    let(:service) { double('Services::Authorizations::UpdateEmail') }
    let(:notification_service) { double('Services::Authorizations::SendConfirmationMail') }

    it do
      expect(Services::Authorizations::UpdateEmail).to receive(:new).and_return(service)
      expect(service).to receive(:call).with(auth, email).and_return(auth)
      expect(Services::Authorizations::SendConfirmationMail).to receive(:new).and_return(notification_service)
      expect(notification_service).to receive(:call).with(auth)
      is_expected.to redirect_to new_user_session_path
    end

    context 'when token expired' do
      before do
        allow(service).to receive(:call).with(auth, email).and_raise(Services::Authorizations::UpdateEmail::ExpiredError)
      end

      it do
        expect(Services::Authorizations::UpdateEmail).to receive(:new).and_return(service)
        expect(service).to receive(:call).with(auth, email)
        expect(Services::Authorizations::SendConfirmationMail).not_to receive(:new)
        is_expected.to redirect_to root_path
      end
    end

    context 'when auth not found' do
      let(:enter_email_token) { 'not_found_token' }

      it do
        expect(Services::Authorizations::UpdateEmail).not_to receive(:new)
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #confirm_email' do
    subject { get :confirm_email, params: { confirm_email_token: confirm_email_token } }

    let!(:auth) { create(:authorization, :with_confirm_email_token) }
    let(:confirm_email_token) { auth.confirm_email_token }

    let(:service) { double('Services::Authorizations::ConfirmEmail') }

    it do
      expect(Services::Authorizations::ConfirmEmail).to receive(:new).and_return(service)
      expect(service).to receive(:call).with(auth)
      is_expected.to redirect_to new_user_session_path
    end

    context 'when token expired' do
      before do
        allow(service).to receive(:call).with(auth).and_raise(Services::Authorizations::ConfirmEmail::ExpiredError)
      end

      it do
        expect(Services::Authorizations::ConfirmEmail).to receive(:new).and_return(service)
        expect(service).to receive(:call).with(auth)
        is_expected.to redirect_to root_path
      end
    end

    context 'when auth not found' do
      let(:confirm_email_token) { 'not_found_token' }

      it do
        expect(Services::Authorizations::ConfirmEmail).not_to receive(:new)
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
