require "application_system_test_case"

module Authentication
  class PasswordResetsTest < ApplicationSystemTestCase
    setup do
      @user = users(:joe_doe)
    end

    test 'user resets password' do
      visit new_user_session_path
      click_on 'Forgot your password?'

      fill_in 'Email', with: @user.email
      click_on 'Send me reset password instructions'

      assert_current_path new_user_session_path(I18n.locale)
      assert_selector 'p.notice', text: I18n.t('devise.passwords.send_instructions')
    end

    test 'user tries to reset password with an email that does not exist' do
      visit new_user_session_path
      click_on 'Forgot your password?'

      fill_in 'Email', with: 'not_existing_email@example.com'
      click_on 'Send me reset password instructions'

      assert_selector 'li', text: 'Email not found'
    end
  end
end
