require 'rails_helper'

feature 'user can sign in via github' do
  background { visit new_user_session_path }

  shared_examples 'success login' do |email|
    given!(:user) { create(:user) }

    scenario do
      expect(page).to have_content 'Sign in with GitHub'

      mock_github_auth_hash(email || user.email)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
      expect(page).to have_content 'Sign out'
    end
  end

  context "when user doesn't exist" do
    it_behaves_like 'success login', 'oauthtest@test.com'
  end

  context 'when user exist' do
    it_behaves_like 'success login', nil
  end

  context 'when invalid credentials' do
    scenario do
      expect(page).to have_content 'Sign in with GitHub'

      mock_invalid_credentials(:github)
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      expect(page).not_to have_content 'Sign out'
    end
  end
end
