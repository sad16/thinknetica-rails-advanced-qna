require 'rails_helper'

RSpec.describe FilePolicy do
  subject { described_class }

  let(:user) { create(:user) }

  permissions :destroy? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:answer, :with_file, user: user).files.first)
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:answer, :with_file).files.first)
    end
  end
end
