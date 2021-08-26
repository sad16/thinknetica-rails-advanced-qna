require 'rails_helper'

RSpec.describe Services::SendNotifications, type: :service do
  let!(:question) { create(:question) }
  let!(:notifications) { create_list(:notification, 3, question: question) }
  let!(:answer) { create(:answer, question: question) }

  let(:users) { notifications.map(&:user) << question.user }

  let(:mail) { double('NotificationMailer') }

  before do
    Answer.skip_callback(:commit, :after, :send_notification)
    allow(mail).to receive(:deliver_later)
  end

  after do
    Answer.set_callback(:commit, :after, :send_notification)
  end

  describe '#call' do
    it do
      users.each { |user| expect(NotificationMailer).to receive(:new_answer).with(user, answer).and_return(mail) }
      subject.call(answer)
    end
  end
end
