require 'rails_helper'

RSpec.describe Services::Authorizations::SendConfirmationMail, type: :service do
  subject { service.call(auth) }

  let(:service) { described_class.new }
  let(:auth) { create(:authorization, :with_confirm_email_token) }

  let(:mail) { double('mail') }

  before do
    allow(AuthorizationMailer).to receive(:confirmation_email).with(auth).and_return(mail)
  end

  describe '#call' do
    it do
      expect(AuthorizationMailer).to receive(:confirmation_email).with(auth)
      expect(mail).to receive(:deliver_later)
      subject
    end

    context 'without email' do
      let(:auth) { create(:authorization) }

      it do
        expect(AuthorizationMailer).not_to receive(:confirmation_email)
        subject
      end
    end
  end
end
