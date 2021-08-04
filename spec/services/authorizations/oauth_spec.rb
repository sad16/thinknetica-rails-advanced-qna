require 'rails_helper'

RSpec.describe Services::Authorizations::Oauth, type: :service do
  subject { service.call(omniauth_data) }

  let(:service) { described_class.new }
  let(:omniauth_data) { OmniAuth::AuthHash.new(auth_hash) }
  let(:auth_hash) do
    { provider: 'github', uid: '1', info: { email: email } }
  end
  let(:email) { 'test@test.com' }

  shared_examples 'oauth with email' do
    it do
      result = subject
      expect(result[:user]).to be_a(User)
      expect(result[:auth]).to be_a(Authorization)
    end

    it do
      result = subject
      expect(result[:auth].user_id).to be(result[:user].id)
    end

    it { expect(subject[:user].email).to eq(email) }
    it { expect(subject[:auth].email_confirmation_at).to be_a(Time) }
  end

  shared_examples 'oauth without email' do
    it do
      result = subject
      expect(result[:user]).to be nil
      expect(result[:auth]).to be_a(Authorization)
    end

    it do
      auth = subject[:auth]
      expect(auth).to have_attributes(
                        email: nil,
                        enter_email_token: String,
                        enter_email_token_expires_at: Time,
                        confirm_email_token: nil,
                        confirm_email_token_expires_at: nil
                      )
    end
  end

  describe '#call' do
    context 'with email' do
      context 'when auth not exist and user not exist' do
        it_behaves_like 'oauth with email'

        it { expect { subject }.to change { User.count }.by(1) }
        it { expect { subject }.to change { Authorization.count }.by(1) }
      end

      context 'when auth exist and user exist' do
        let!(:auth) { create(:authorization, :with_confirmation_email, provider: 'github', uid: '1', email: email) }
        let!(:user) { create(:user, email: email) }

        it_behaves_like 'oauth with email'

        it { expect { subject }.not_to change { User.count } }
        it { expect { subject }.not_to change { Authorization.count } }
      end

      context 'when auth exist and user not exist' do
        let!(:auth) { create(:authorization, :with_confirmation_email, provider: 'github', uid: '1', email: email) }

        it_behaves_like 'oauth with email'

        it { expect { subject }.to change { User.count }.by(1) }
        it { expect { subject }.not_to change { Authorization.count } }
      end

      context 'when auth not exist and user exist' do
        let!(:user) { create(:user, email: email) }

        it_behaves_like 'oauth with email'

        it { expect { subject }.not_to change { User.count } }
        it { expect { subject }.to change { Authorization.count }.by(1) }
      end
    end

    context 'without email' do
      let(:auth_hash) do
        { provider: 'vkontakte', uid: '1', info: {} }
      end

      it_behaves_like 'oauth without email'

      it { expect { subject }.not_to change { User.count } }
      it { expect { subject }.to change { Authorization.count }.by(1) }

      context 'when auth exist' do
        context 'with enter email token' do
          let!(:auth) { create(:authorization, :with_enter_email_token, provider: 'vkontakte', uid: '1') }

          it_behaves_like 'oauth without email'

          it { expect { subject }.to change { auth.reload.enter_email_token } }
          it { expect { subject }.to change { auth.reload.enter_email_token_expires_at } }

          it { expect { subject }.not_to change { User.count } }
          it { expect { subject }.not_to change { Authorization.count } }
        end

        context 'with email and confirm email token' do
          let!(:auth) { create(:authorization, :with_confirm_email_token, provider: 'vkontakte', uid: '1', email: email) }

          it_behaves_like 'oauth without email'

          it { expect { subject }.to change { auth.reload.email }.from(email).to(nil) }
          it { expect { subject }.to change { auth.reload.enter_email_token }.from(nil).to(String) }
          it { expect { subject }.to change { auth.reload.enter_email_token_expires_at }.from(nil).to(Time) }
          it { expect { subject }.to change { auth.reload.confirm_email_token }.from(String).to(nil) }
          it { expect { subject }.to change { auth.reload.confirm_email_token_expires_at }.from(Time).to(nil) }

          it { expect { subject }.not_to change { User.count } }
          it { expect { subject }.not_to change { Authorization.count } }
        end

        context 'with confirmation email' do
          let!(:auth) { create(:authorization, :with_confirmation_email, provider: 'vkontakte', uid: '1', email: email) }

          context 'when user not exist' do
            it_behaves_like 'oauth with email'

            it { expect { subject }.to change { User.count }.by(1) }
            it { expect { subject }.not_to change { Authorization.count } }
          end

          context 'when user exist' do
            let!(:user) { create(:user, email: email) }

            it_behaves_like 'oauth with email'

            it { expect { subject }.not_to change { User.count } }
            it { expect { subject }.not_to change { Authorization.count } }
          end
        end
      end
    end
  end
end
