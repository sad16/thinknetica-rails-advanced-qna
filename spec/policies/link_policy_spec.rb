require 'rails_helper'

RSpec.describe LinkPolicy do
  subject { described_class }

  let(:user) { create(:user) }

  permissions :destroy? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:link, linkable: create(:answer, user: user)))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:link, linkable: create(:answer)))
    end
  end
end
