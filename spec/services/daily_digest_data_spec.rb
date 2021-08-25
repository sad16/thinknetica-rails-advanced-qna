require 'rails_helper'

RSpec.describe Services::DailyDigestData, type: :service do
  let!(:today_question) { create(:question) }
  let!(:yesterday_question) { create(:question, created_at: Date.yesterday) }

  let(:data) do
    [
      {
        id: yesterday_question.id,
        title: yesterday_question.title
      }
    ]
  end

  describe '#call' do
    it do
      expect(subject.call).to eq(data)
    end
  end
end
