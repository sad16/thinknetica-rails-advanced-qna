require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  describe 'uniqueness user_id and question_id' do
    subject { Notification.create!(user: user, question: question) }

    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:notification) { create(:notification, user: user, question: question) }

    it do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: User has already been taken')
    end
  end
end
