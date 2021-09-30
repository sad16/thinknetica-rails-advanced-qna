require 'sphinx_helper'

feature 'user can search for comment' do
  given!(:user) { create(:user, email: 'test@test.com') }

  given!(:comment1) { create(:comment, user: user, text: 'Foo') }
  given!(:comment2) { create(:comment, text: 'Foo Bar') }

  background { login(user) }

  background { visit comments_search_index_path }

  describe 'searches' do
    context 'when global' do
      scenario 'search comments', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#comments-search-form' do
            fill_in 'Global', with: 'Bar'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_content 'Foo Bar'
          end
        end
      end
    end

    context 'when body' do
      scenario 'search comments', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#comments-search-form' do
            fill_in 'Text', with: 'Foo'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_content 'Foo'

            expect(page).to have_content 'Foo Bar'
          end
        end
      end
    end

    context 'when author' do
      scenario 'search comments', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#comments-search-form' do
            fill_in 'Author', with: 'test'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_content 'Foo'
          end
        end
      end
    end

    context 'with errors' do
      scenario 'search comments', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#comments-search-form' do
            click_on 'Search'

            expect(page).to have_content 'Error: search without params'
          end
        end
      end
    end
  end
end
