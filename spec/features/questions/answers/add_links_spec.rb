require 'rails_helper'

feature 'user can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:link_name) { 'Google link' }
  given(:url) { 'https://google.ru' }

  background { login(user) }

  background { visit question_path(question) }

  shared_examples 'links' do
    scenario 'add valid link' do
      within '.answers' do
        expect(page).to have_link link_name, href: url
      end
    end

    context 'when gist link' do
      given(:link_name) { 'Gist link' }
      given(:url) { 'https://gist.github.com/sad16/2f0fdb94eabdfff07781724a77067a1b' }

      scenario 'adds link when give an answer' do
        within '.answers' do
          expect(page).to have_link link_name, href: url

          expect(page).to have_content 'gistfile1.txt'
          expect(page).to have_content 'TEST GIST 1 FILE 1'
          expect(page).to have_content 'gistfile2.txt'
          expect(page).to have_content 'TEST GIST 1 FILE 2'
        end
      end
    end

    context 'add invalid link'  do
      given(:link_name) { 'Invalid link' }
      given(:url) { 'invalid' }

      scenario do
        expect(page).not_to have_link link_name, href: url
        expect(page).to have_content 'Links url is not a valid URL'
      end
    end
  end

  describe 'adds link when give an answer', js: true do
    background do
      fill_in 'Body', with: 'Answer body'

      fill_in 'Link name', with: link_name
      fill_in 'Url', with: url

      click_on 'Answer'
    end

    it_behaves_like 'links'
  end

  describe 'adds link when edit answer', js: true do
    background do
      click_on 'Edit answer'

      within '.edit-answer-form' do
        click_on 'Add link'

        fill_in 'Link name', with: link_name
        fill_in 'Url', with: url

        click_on 'Save'
      end
    end

    it_behaves_like 'links'
  end
end
