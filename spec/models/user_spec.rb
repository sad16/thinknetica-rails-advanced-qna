require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe '#author_of' do
    subject { user.author_of(resource) }

    let(:user) { create(:user) }
    let(:resource) { double user_id: user_id }
    let(:user_id) { user.id }

    it do
      is_expected.to be true
    end

    context 'when the user is not the author' do
      let(:second_user) { create(:user) }
      let(:user_id) { second_user.id }

      it do
        is_expected.to be false
      end
    end
  end
end
