require "application_system_test_case"

module Authentication
  class LockInstructionsTest < ApplicationSystemTestCase
    setup do
      @user = users(:joe_doe)
    end

    test 'user did not receive unlock instructions' do
      @user.update(locked_at: Time.current)

      visit new_user_session_path
      click_on "Didn't receive unlock instructions?"

      fill_in 'Email', with: @user.email
      click_on 'Resend unlock instructions'

      assert_current_path new_user_unlock_path(I18n.locale)
      assert_selector 'p.notice', text: I18n.t('devise.unlocks.send_instructions')
    end

    test 'user is not locked' do
      visit new_user_session_path
      click_on "Didn't receive unlock instructions?"

      fill_in 'Email', with: @user.email
      click_on 'Resend unlock instructions'

      assert_current_path new_user_unlock_path(I18n.locale)
      assert_selector 'li', text: 'Email was not locked'
    end

    test 'user/email does not exist' do
      visit new_user_session_path
      click_on "Didn't receive unlock instructions?"

      fill_in 'Email', with: 'not_existing_email@example.com'
      click_on 'Resend unlock instructions'

      assert_current_path new_user_unlock_path(I18n.locale)
      assert_selector 'li', text: 'Email not found'
    end
  end
end
