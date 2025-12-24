require "application_system_test_case"

module Authentication
  class SignInsTest < ApplicationSystemTestCase
    setup do
      @user = users(:joe_doe)
    end

    test 'user logs in (English)' do
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'

      assert_current_path root_path(I18n.locale)
      assert_selector 'h1', text: 'All Passwords'
    end

    test 'user tries to log in with invalid credentials (English)' do
      visit new_user_session_path(I18n.locale)
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: 'wrong_password'
      click_on 'Log in'

      assert_current_path new_user_session_path(I18n.locale)
      assert_selector 'p.alert', text: 'Invalid Email or password.'
    end

    test 'user logs in (Spanish)' do
      visit new_user_session_path(locale: :es)
      fill_in 'Email', with: @user.email
      fill_in 'Contraseña', with: 'password'
      click_button 'Iniciar sesión'

      assert_current_path root_path(locale: :es)
      assert_selector 'h1', text: 'Todas las contraseñas'
    end

    test 'user tries to log in with invalid credentials (Spanish)' do
      visit new_user_session_path(locale: :es)
      fill_in 'Email', with: @user.email
      fill_in 'Contraseña', with: 'wrong_password'
      click_button 'Iniciar sesión'

      assert_current_path new_user_session_path(locale: :es)
      assert_selector 'p.alert', text: 'Email y/o contraseña inválidos.'
    end
  end
end
