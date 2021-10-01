require 'sphinx_helper'

feature 'user can search for question' do
  given!(:user) { create(:user, email: 'test@test.com') }

  given!(:question1) { create(:question, user: user, title: 'Foo', body: 'Bar') }
  given!(:question2) { create(:question, title: 'XYZ', body: 'Foo') }
  given!(:question3) { create(:question, title: 'Title', body: 'Body') }

  background { login(user) }

  background { visit questions_search_index_path }

  describe 'searches' do
    context 'when global' do
      scenario 'search questions', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#questions-search-form' do
            fill_in 'Global', with: 'Foo'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_link 'Link'
            expect(page).to have_content 'Foo'
            expect(page).to have_content 'Bar'

            expect(page).to have_link 'Link'
            expect(page).to have_content 'XYZ'
            expect(page).to have_content 'Foo'
          end
        end
      end
    end

    context 'when title' do
      scenario 'search questions', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#questions-search-form' do
            fill_in 'Title', with: 'Title'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_link 'Link'
            expect(page).to have_content 'Title'
            expect(page).to have_content 'Body'
          end
        end
      end
    end

    context 'when body' do
      scenario 'search questions', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#questions-search-form' do
            fill_in 'Body', with: 'Body'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_link 'Link'
            expect(page).to have_content 'Title'
            expect(page).to have_content 'Body'
          end
        end
      end
    end

    context 'when author' do
      scenario 'search questions', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#questions-search-form' do
            fill_in 'Author', with: 'test'
            click_on 'Search'
          end

          within '.result' do
            expect(page).to have_link 'Link'
            expect(page).to have_content 'Foo'
            expect(page).to have_content 'Bar'
          end
        end
      end
    end

    context 'with errors' do
      scenario 'search questions', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          within '#questions-search-form' do
            click_on 'Search'

            expect(page).to have_content 'Error: search without params'
          end
        end
      end
    end
  end
end
