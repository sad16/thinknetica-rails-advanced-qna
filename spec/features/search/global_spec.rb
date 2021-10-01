require 'sphinx_helper'

feature 'user can global search' do
  given!(:user1) { create(:user, email: 'test@test.com') }
  given!(:user2) { create(:user, email: 'foo@bar.com') }

  given!(:question) { create(:question, title: 'Foo Question', body: 'Bar Question') }
  given!(:answer) { create(:answer, body: 'Foo Answer') }
  given!(:comment) { create(:comment, text: 'Foo Comment') }

  background { login(user1) }

  background { visit global_search_index_path }

  describe 'searches' do
    scenario 'global search', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '#global-search-form' do
          fill_in 'Global', with: 'foo'
          click_on 'Search'
        end

        within '.result' do
          expect(page).to have_content 'foo@bar.com'

          expect(page).to have_link 'Link'
          expect(page).to have_content 'Foo Question'
          expect(page).to have_content 'Bar Question'

          expect(page).to have_link 'Link'
          expect(page).to have_content 'Foo Answer'

          expect(page).to have_content 'Foo Comment'
        end
      end
    end

    context 'with errors' do
      scenario 'global search', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#global-search-form' do
            click_on 'Search'

            expect(page).to have_content 'Error: search without params'
          end
        end
      end
    end
  end
end
