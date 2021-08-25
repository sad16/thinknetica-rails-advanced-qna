require 'rails_helper'

RSpec.describe NotificationPolicy do
  subject { described_class }

  let(:user) { create(:user) }

  permissions :destroy? do
    it 'grant access if user is owner' do
      expect(subject).to permit(user, create(:notification, user: user))
    end

    it 'denies access if user is not owner' do
      expect(subject).not_to permit(user, create(:notification))
    end
  end
end
