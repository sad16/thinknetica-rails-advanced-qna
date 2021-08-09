require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class }

  let(:user) { create(:user) }

  permissions :update? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:question, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:question))
    end
  end

  permissions :destroy? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:question, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:question))
    end
  end
end
