require 'rails_helper'

RSpec.describe Services::SendDailyDigest, type: :service do
  let!(:users) { create_list(:user, 3) }
  let!(:question) { create(:question, user: users.first) }

  let(:service) { double('Services::DailyDigestData') }
  let(:mail) { double('DailyDigestMailer') }
  let(:questions_data) do
    [{ id: question.id, title: question.title }]
  end

  before do
    allow(Services::DailyDigestData).to receive(:new).and_return(service)
    allow(service).to receive(:call).and_return(questions_data)
    allow(mail).to receive(:deliver_later)
  end

  describe '#call' do
    it do
      users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_return(mail) }
      subject.call
    end

    context 'without questions data' do
      let(:questions_data) { [] }

      it do
        expect(User).not_to receive(:find_each)
        subject.call
      end
    end
  end
end
