require 'sphinx_helper'

feature 'user can search for user' do
  given!(:user1) { create(:user, email: 'foo@bar.com') }
  given!(:user2) { create(:user, email: 'xyz@test.com') }

  background { login(user1) }

  background { visit users_search_index_path }

  describe 'searches' do
    context 'when global' do
      scenario 'search users', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#users-search-form' do
            fill_in 'Global', with: 'test'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_content 'xyz@test.com'
          end
        end
      end
    end

    context 'when email' do
      scenario 'search users', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#users-search-form' do
            fill_in 'Email', with: 'foo'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_content 'foo@bar.com'
          end
        end
      end
    end

    context 'with errors' do
      scenario 'search users', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#users-search-form' do
            click_on 'Search'

            expect(page).to have_content 'Error: search without params'
          end
        end
      end
    end
  end
end
