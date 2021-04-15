require 'rails_helper'

feature 'user can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given!(:user) { create(:user) }
  given(:link_name) { 'Google link' }
  given(:url) { 'https://google.ru' }

  background { login(user) }

  shared_examples 'links' do
    scenario 'adds valid link' do
      expect(page).to have_link link_name, href: url
    end

    context 'when gist link' do
      given(:link_name) { 'Gist link' }
      given(:url) { 'https://gist.github.com/sad16/2f0fdb94eabdfff07781724a77067a1b' }

      scenario 'adds link when asks question' do
        expect(page).to have_link link_name, href: url

        expect(page).to have_content 'gistfile1.txt'
        expect(page).to have_content 'TEST GIST 1 FILE 1'
        expect(page).to have_content 'gistfile2.txt'
        expect(page).to have_content 'TEST GIST 1 FILE 2'
      end
    end

    context 'add invalid link' do
      given(:link_name) { 'Invalid link' }
      given(:url) { 'invalid' }

      scenario do
        expect(page).not_to have_link link_name, href: url
        expect(page).to have_content 'Links url is not a valid URL'
      end
    end
  end

  describe 'adds link when asks question', js: true do
    background { visit new_question_path }

    background do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'

      fill_in 'Link name', with: link_name
      fill_in 'Url', with: url

      click_on 'Ask'
    end

    it_behaves_like 'links'
  end

  describe 'adds link when edit question', js: true do
    given!(:question) { create(:question, user: user) }

    background { visit question_path(question) }

    background do
      click_on 'Edit question'

      within '.edit-question-form' do
        click_on 'Add link'

        fill_in 'Link name', with: link_name
        fill_in 'Url', with: url

        click_on 'Save'
      end
    end

    it_behaves_like 'links'
  end
end
