require 'rails_helper'

feature 'user can add reward to question' do
  given(:user) { create(:user) }

  background { login(user) }

  background { visit new_question_path }

  background do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
  end

  context 'with valid params' do
    scenario 'tries to create question with reward' do
      fill_in 'Reward name', with: 'BEST OF THE BEST'
      attach_file 'Image', "#{Rails.root}/spec/fixtures/files/image_test_file.jpeg"

      click_on 'Ask'

      expect(page).to have_content 'BEST OF THE BEST'
    end
  end

  context 'with invalid params' do
    scenario 'tries to create question with invalid reward' do
      attach_file 'Image', "#{Rails.root}/spec/fixtures/files/image_test_file.jpeg"

      click_on 'Ask'

      expect(page).to have_content "Reward name can't be blank"
    end
  end

end