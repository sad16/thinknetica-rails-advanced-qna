require 'rails_helper'

RSpec.describe VotePolicy do
  subject { described_class }

  let(:user) { create(:user) }

  permissions :show? do
    it 'grant access if user is not voteable author' do
      expect(subject).to permit(user, create(:vote, voteable: create(:answer)))
    end

    it 'denies access if vote is nil' do
      expect(subject).not_to permit(user, nil)
    end

    it 'denies access if user is voteable author' do
      expect(subject).not_to permit(user, create(:vote, voteable: create(:answer, user: user)))
    end
  end

  permissions :destroy? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:vote, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:vote))
    end
  end
end
