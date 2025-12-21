require "application_system_test_case"

module Authentication
  class SignUpsTest < ApplicationSystemTestCase
    test 'user signs up' do
      initial_count = User.count

      visit new_user_registration_path
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'

      # Wait for redirect to complete
      assert_current_path new_user_session_path(I18n.locale)

      # Now check that user was created
      assert_equal initial_count + 1, User.count, 'User should be created after signup'

      user = User.find_by(email: 'test@example.com')
      assert user.present?
      assert_not user.confirmed?
      assert_selector 'p.notice', text: I18n.t('devise.registrations.signed_up_but_unconfirmed')
    end

    test 'user tries to sign up with an email that is already taken' do
      user = users(:joe_doe)

      visit new_user_registration_path(I18n.locale)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'

      assert_current_path new_user_registration_path(I18n.locale)
      assert_selector 'li', text: 'Email has already been taken'
    end
  end
end
