require 'rails_helper'

RSpec.describe NotificationsJob, type: :job do
  let(:service) { double('Services::SendNotifications') }
  let(:answer) { create(:answer) }

  before do
    Answer.skip_callback(:commit, :after, :send_notification)
    allow(Services::SendNotifications).to receive(:new).and_return(service)
    allow(service).to receive(:call).with(answer)
  end

  after do
    Answer.set_callback(:commit, :after, :send_notification)
  end

  it do
    expect(service).to receive(:call).with(answer)
    described_class.perform_now(answer)
  end
end
