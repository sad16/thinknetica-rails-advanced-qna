require 'rails_helper'

RSpec.describe Services::Authorizations::ConfirmEmail, type: :service do
  subject { service.call(auth) }

  let(:service) { described_class.new }
  let(:auth) { create(:authorization, :with_confirm_email_token) }

  describe '#call' do
    it { is_expected.to be true }

    it do
      expect { subject }.to change { auth.email_confirmation_at }.from(nil).to(Time)
      expect(auth).to have_attributes(
                        confirm_email_token: nil,
                        confirm_email_token_expires_at: nil,
                      )
    end

    context 'when token expired' do
      let(:auth) { create(:authorization, :with_confirm_email_token, confirm_email_token_expires_at: 2.hours.ago) }

      it do
        expect { subject }.to raise_error(described_class::ExpiredError)
        expect(auth).to have_attributes(confirm_email_token: nil, confirm_email_token_expires_at: nil)
      end
    end
  end
end
