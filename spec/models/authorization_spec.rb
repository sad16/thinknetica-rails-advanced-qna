require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user).optional }

  it { should validate_presence_of(:provider) }
  it { should validate_presence_of(:uid) }

  describe 'uniqueness uid and provider' do
    subject { Authorization.create!(provider: provider, uid: uid) }

    let(:provider) { 'github' }
    let(:uid) { '1' }

    before do
      Authorization.create!(provider: provider, uid: uid)
    end

    it do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Uid has already been taken')
    end
  end
end
