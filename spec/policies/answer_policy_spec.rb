require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  let(:user) { create(:user) }

  permissions :update? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:answer))
    end
  end

  permissions :destroy? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:answer))
    end
  end

  permissions :mark_as_best? do
    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:answer, question: create(:question, user: user)))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, create(:answer, question: create(:question)))
    end
  end
end
