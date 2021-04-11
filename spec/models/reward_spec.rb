require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:name) }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe '.by_user scope' do
    subject { described_class.by_user(user) }

    let!(:question) { create(:question, :with_reward, :with_best_answer) }
    let(:user) { question.best_answer.user }

    it do
      is_expected.to include(question.reward)
    end

    context 'when user has not rewards' do
      let(:user) { create(:user) }

      it do
        is_expected.to be_empty
      end
    end
  end
end
