require 'sphinx_helper'

feature 'user can search for answer' do
  given!(:user) { create(:user, email: 'test@test.com') }

  given!(:answer1) { create(:answer, user: user, body: 'Foo') }
  given!(:answer2) { create(:answer, body: 'Foo Bar') }

  background { login(user) }

  background { visit answers_search_index_path }

  describe 'searches' do
    context 'when global' do
      scenario 'search answers', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#answers-search-form' do
            fill_in 'Global', with: 'Bar'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_link 'Link'
            expect(page).to have_content 'Foo Bar'
          end
        end
      end
    end

    context 'when body' do
      scenario 'search answers', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#answers-search-form' do
            fill_in 'Body', with: 'Foo'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_link 'Link'
            expect(page).to have_content 'Foo'

            expect(page).to have_link 'Link'
            expect(page).to have_content 'Foo Bar'
          end
        end
      end
    end

    context 'when author' do
      scenario 'search answers', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#answers-search-form' do
            fill_in 'Author', with: 'test'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_link 'Link'
            expect(page).to have_content 'Foo'
          end
        end
      end
    end

    context 'with errors' do
      scenario 'search answers', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#answers-search-form' do
            click_on 'Search'

            expect(page).to have_content 'Error: search without params'
          end
        end
      end
    end
  end
end
