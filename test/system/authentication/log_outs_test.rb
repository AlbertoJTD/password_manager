require "application_system_test_case"

module Authentication
  class LogOutsTest < ApplicationSystemTestCase
    setup do
      @user = users(:joe_doe)
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'
    end

    test 'user logs out' do
      click_on 'Logout'
      assert_current_path new_user_session_path(I18n.locale)
      assert_selector 'p.alert', text: I18n.t('devise.failure.unauthenticated')
    end
  end
end
