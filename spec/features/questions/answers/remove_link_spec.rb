require 'rails_helper'

feature 'user can remove answer links'  do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, user: user, question: question) }
  given!(:link) { answer.links.first }

  background { login(user) }

  background { visit question_path(question) }

  describe 'tries remove link', js: true do
    scenario do
      within '.answer .links' do
        expect(page).to have_link link.name, href: link.url

        click_on 'Delete link'

        expect(page).not_to have_link link.name, href: link.url
      end
    end
  end
end
