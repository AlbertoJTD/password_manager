require "application_system_test_case"

module Authentication
  class SignInsTest < ApplicationSystemTestCase
    setup do
      @user = users(:joe_doe)
    end

    I18n.available_locales.each do |locale|
      config = {
        password_label: I18n.t('devise.sessions.new.form.password_label', locale: locale),
        submit: I18n.t('devise.sessions.new.submit', locale: locale),
        heading: I18n.t('passwords.index.title', locale: locale)
      }.freeze

      test "user logs in (#{locale})" do
        visit new_user_session_path(locale: locale)

        fill_in 'Email', with: @user.email
        fill_in config[:password_label], with: 'password'
        click_button config[:submit]

        assert_current_path root_path(locale: locale)
        assert_selector 'h1', text: config[:heading]
      end

      test "user tries to log in with invalid credentials (#{locale})" do
        visit new_user_session_path(locale: locale)

        fill_in 'Email', with: @user.email
        fill_in config[:password_label], with: 'wrong_password'
        click_button config[:submit]

        assert_current_path new_user_session_path(locale: locale)
        assert_selector 'p.alert', text: I18n.t('devise.failure.invalid', locale: locale, authentication_keys: 'Email')
      end
    end
  end
end
