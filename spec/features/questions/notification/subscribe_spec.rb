require 'rails_helper'

feature 'user can subscribe to question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  background { login(user) }
  background { visit question_path(question) }

  describe 'subscribe', js: true do
    scenario do
      expect(page).to have_link 'Subscribe'

      click_on 'Subscribe'

      expect(page).to have_link 'Unsubscribe'
    end
  end
end
