require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:voteable) }

  it { should validate_presence_of(:value) }
  it { should validate_inclusion_of(:value).in_array(Vote::VALUES) }

  describe 'uniqueness user_id and voteable' do
    subject { Vote.create!(user: user, voteable: question, value: 1) }

    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:vote) { create(:vote, user: user, voteable: question) }

    it do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: User has already been taken')
    end
  end
end
