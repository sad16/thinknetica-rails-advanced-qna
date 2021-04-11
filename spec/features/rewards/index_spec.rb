require 'rails_helper'

feature 'user can see his rewards' do
  given!(:question) { create(:question, :with_reward) }
  given!(:answer) { create(:answer, :best, question: question) }

  context 'when user has rewards' do
    scenario 'tries to show rewards' do
      login(answer.user)

      visit rewards_path

      expect(page).to have_content question.reward.name
    end
  end

  context 'when user has not rewards' do
    scenario 'tries to show rewards' do
      login(question.user)

      visit rewards_path

      expect(page).to have_content 'You have no rewards'
    end
  end

end
