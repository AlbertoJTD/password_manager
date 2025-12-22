require "application_system_test_case"

module Navigation
  class LocaleSwitchesTest < ApplicationSystemTestCase
    test 'default locale is English' do
      user = users(:joe_doe)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'

      assert_current_path root_path(locale: :en)
      assert_selector 'h1', text: 'All Passwords'
      assert_selector 'a', text: 'ES'
    end

    test 'shows English link as active and Spanish link as inactive' do
      user = users(:joe_doe)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'

      assert_current_path root_path(locale: :en)
      assert_selector 'h1', text: 'All Passwords'
      assert_selector 'a', text: 'ES'

      # Active link
      assert_selector 'a[href="/en"].bg-blue-500.text-white', text: 'EN'

      # Inactive link
      assert_selector 'a[href="/es"].text-gray-600.hover\\:bg-gray-100', text: 'ES'

      # Ensure the inactive link does not have active classes
      assert_no_selector 'a[href="/es"].bg-blue-500', text: 'ES'
    end

    test 'user switches locale to Spanish' do
      user = users(:joe_doe)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'

      click_on 'ES'
      assert_current_path root_path(locale: :es)
      assert_selector 'h1', text: 'Todas las contraseñas'
    end

    test 'shows Spanish link as active and English link as inactive' do
      user = users(:joe_doe)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'

      click_on 'ES'
      assert_current_path root_path(locale: :es)
      assert_selector 'h1', text: 'Todas las contraseñas'

      # Active link
      assert_selector 'a[href="/es"].bg-blue-500.text-white', text: 'ES'

      # Inactive link
      assert_selector 'a[href="/en"].text-gray-600.hover\\:bg-gray-100', text: 'EN'

      # Ensure the inactive link does not have active classes
      assert_no_selector 'a[href="/en"].bg-blue-500', text: 'EN'
    end
  end
end
