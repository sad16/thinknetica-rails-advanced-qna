require 'rails_helper'

RSpec.describe Services::Authorizations::UpdateEmail, type: :service do
  subject { service.call(auth, email) }

  let(:service) { described_class.new }
  let(:auth) { create(:authorization, :with_enter_email_token) }
  let(:email) { 'test@test.com' }

  describe '#call' do
    it do
      expect { subject }.to change { auth.email }.from(nil).to(email)
      expect(auth).to have_attributes(
                        confirm_email_token: String,
                        confirm_email_token_expires_at: Time,
                        enter_email_token: nil,
                        enter_email_token_expires_at: nil
                      )
    end

    it 'returns auth' do
      expect(subject).to be_a(Authorization)
    end

    context 'when token expired' do
      let(:auth) { create(:authorization, :with_enter_email_token, enter_email_token_expires_at: 10.minutes.ago) }

      it do
        expect { subject }.to raise_error(described_class::ExpiredError)
        expect(auth).to have_attributes(enter_email_token: nil, enter_email_token_expires_at: nil)
      end
    end
  end
end
