require 'rails_helper'

feature 'user can see his rewards' do
  given!(:reward) { create(:reward, :assigned) }

  scenario 'tries to show rewards' do
    login(reward.user)

    visit rewards_path

    expect(page).to have_content reward.name
  end

  context 'when user has not rewards' do
    given!(:reward) { create(:reward) }

    scenario 'tries to show rewards' do
      login(reward.question.user)

      visit rewards_path

      expect(page).to have_content 'You have no rewards'
    end
  end

end
