require "application_system_test_case"

module Authentication
  class ConfirmationInstructionsTest < ApplicationSystemTestCase
    setup do
      @user = users(:joe_doe)
    end

    test 'user did not receive confirmation instructions' do
      @user.update(confirmed_at: nil)

      visit new_user_session_path
      click_on "Didn't receive confirmation instructions?"

      fill_in 'Email', with: @user.email
      click_on 'Resend confirmation instructions'

      assert_current_path new_user_confirmation_path(I18n.locale)
      assert_selector 'p.notice', text: I18n.t('devise.confirmations.send_instructions')
    end

    test 'user is already confirmed' do
      visit new_user_session_path
      click_on "Didn't receive confirmation instructions?"

      fill_in 'Email', with: @user.email
      click_on 'Resend confirmation instructions'

      assert_selector 'li', text: 'Email was already confirmed, please try signing in'
    end

    test 'user/email does not exist' do
      visit new_user_session_path
      click_on "Didn't receive confirmation instructions?"

      fill_in 'Email', with: 'not_existing_email@example.com'
      click_on 'Resend confirmation instructions'

      assert_selector 'li', text: 'Email not found'
    end
  end
end
