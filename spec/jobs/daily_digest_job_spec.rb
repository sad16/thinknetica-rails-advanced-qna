require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('Services::SendDailyDigest') }

  before do
    allow(Services::SendDailyDigest).to receive(:new).and_return(service)
  end

  it do
    expect(service).to receive(:call)
    described_class.perform_now
  end
end
