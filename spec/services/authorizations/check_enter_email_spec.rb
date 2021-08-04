require 'rails_helper'

RSpec.describe Services::Authorizations::CheckEnterEmail, type: :service do
  subject { service.call(auth) }

  let(:service) { described_class.new }
  let(:auth) { create(:authorization, :with_enter_email_token) }

  describe '#call' do
    it { is_expected.to be true }

    context 'when token expired' do
      let(:auth) { create(:authorization, :with_enter_email_token, enter_email_token_expires_at: 10.minutes.ago) }

      it do
        expect { subject }.to raise_error(described_class::ExpiredError)
        expect(auth).to have_attributes(enter_email_token: nil, enter_email_token_expires_at: nil)
      end
    end
  end
end
