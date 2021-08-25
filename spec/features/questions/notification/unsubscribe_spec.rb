require 'rails_helper'

feature 'user can unsubscribe to question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:notification) { create(:notification, user: user, question: question) }

  background { login(user) }
  background { visit question_path(question) }

  describe 'unsubscribe', js: true do
    scenario do
      expect(page).to have_link 'Unsubscribe'

      click_on 'Unsubscribe'

      expect(page).to have_link 'Subscribe'
    end
  end
end
