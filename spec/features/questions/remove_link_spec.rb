require 'rails_helper'

feature 'user can remove question links'  do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_link, user: user) }
  given!(:link) { question.links.first }

  background { login(user) }

  background { visit question_path(question) }

  describe 'tries remove link', js: true do
    scenario do
      within '.question .links' do
        expect(page).to have_link link.name, href: link.url

        click_on 'Delete link'

        expect(page).not_to have_link link.name, href: link.url
      end
    end
  end
end
