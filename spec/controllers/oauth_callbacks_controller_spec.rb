require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let(:service_class) { Services::Authorizations::Oauth }
  let(:service) { instance_double(service_class.name) }
  let(:result) do
    { user: user, auth: auth }
  end

  before do
    allow(service_class).to receive(:new).and_return(service)
    allow(service).to receive(:call).with(omniauth_data).and_return(result)
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  before do
    allow(request.env).to receive(:[]).and_call_original
    allow(request.env).to receive(:[]).with('omniauth.auth').and_return(omniauth_data)
  end

  describe '#github' do
    let(:omniauth_data) do
      {
        'provider' => 'github',
        'uid' => 1,
        'info' => {
          'email' => user.email
        }
      }
    end

    let(:user) { create(:user) }
    let(:auth) { create(:authorization, user: user) }

    it do
      expect(service).to receive(:call).with(omniauth_data)

      get :github

      expect(subject.current_user).to eq(user)
      expect(response).to redirect_to root_path
    end
  end

  describe '#vkontakte' do
    let(:omniauth_data) do
      {
        'provider' => 'vkontakte',
        'uid' => 1,
        'info' => {
          'email' => user.email
        }
      }
    end

    let(:user) { create(:user) }
    let(:auth) { create(:authorization, user: user) }

    it do
      expect(service).to receive(:call).with(omniauth_data)

      get :vkontakte

      expect(subject.current_user).to eq(user)
      expect(response).to redirect_to root_path
    end
  end

  context 'without email' do
    let(:omniauth_data) do
      {
        'provider' => 'vkontakte',
        'uid' => 1
      }
    end

    let(:user) { nil }
    let(:auth) { create(:authorization, :with_enter_email_token) }

    it do
      expect(service).to receive(:call).with(omniauth_data)

      get :vkontakte

      expect(response).to redirect_to auth_enter_email_path(enter_email_token: auth.enter_email_token)
    end
  end

  context 'when something went wrong' do
    let(:omniauth_data) { {} }

    let(:user) { nil }
    let(:auth) { nil }

    it do
      expect(service).to receive(:call).with(omniauth_data)

      get :github

      expect(response).to redirect_to root_path
    end
  end
end