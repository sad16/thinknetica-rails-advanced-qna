require 'rails_helper'

feature 'user can sign in via vkontakte' do
  background { clear_emails }

  background { visit new_user_session_path }

  shared_examples 'success login' do |email|
    given!(:user) { create(:user) }

    before do
      email ||= user.email
    end

    scenario do
      expect(page).to have_content 'Sign in with Vkontakte'

      mock_vkontakte_auth_hash
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Enter your email for confirmation'

      fill_in 'Email', with: email
      click_on 'Confirm'

      expect(page).to have_content 'Сonfirmation mail was sent to the email'

      open_email(email)

      expect(current_email).to have_content 'To confirm your email, click on the link'
      current_email.click_link 'Confirm'

      expect(page).to have_content 'Email confirmed. You can sign in'

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
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
      expect(page).to have_content 'Sign in with Vkontakte'

      mock_invalid_credentials(:vkontakte)
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
      expect(page).not_to have_content 'Sign out'
    end
  end
end
