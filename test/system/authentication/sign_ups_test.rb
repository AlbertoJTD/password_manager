require "application_system_test_case"

module Authentication
  class SignUpsTest < ApplicationSystemTestCase
    I18n.available_locales.each do |locale|
      config = {
        email_label: I18n.t('devise.registrations.new.form.email_label', locale: locale),
        password_label: I18n.t('devise.registrations.new.form.password_label', locale: locale, minimum_password_length: 6),
        password_confirmation_label: I18n.t('devise.registrations.new.form.password_confirmation_label', locale: locale),
        submit: I18n.t('devise.registrations.new.form.submit', locale: locale),
        signed_up_but_unconfirmed: I18n.t('devise.registrations.signed_up_but_unconfirmed', locale: locale),
        already_taken_error: I18n.t('errors.format',
          attribute: I18n.t('activerecord.attributes.user.email', locale: locale),
          message: I18n.t('errors.messages.taken', locale: locale),
          locale: locale),
        taken: locale == :en ? 'Email has already been taken' : 'Email ya ha sido tomado'
      }

      test "user signs up (#{locale})" do
        visit new_user_registration_path(locale: locale)
        fill_in config[:email_label], with: 'test@example.com'
        fill_in config[:password_label], with: 'password'
        fill_in config[:password_confirmation_label], with: 'password'
        click_button config[:submit]

        # Wait for redirect to complete
        assert_current_path new_user_session_path(locale: locale)

        user = User.find_by(email: 'test@example.com')
        assert user.present?
        assert_not user.confirmed?
        assert_selector 'p.notice', text: config[:signed_up_but_unconfirmed]
      end

      test "user tries to sign up with an email that is already taken (#{locale})" do
        user = users(:joe_doe)

        visit new_user_registration_path(locale: locale)
        fill_in config[:email_label], with: user.email
        fill_in config[:password_label], with: 'password'
        fill_in config[:password_confirmation_label], with: 'password'
        click_button config[:submit]

        assert_current_path new_user_registration_path(locale: locale)
        assert_selector 'li', text: config[:already_taken_error]
      end
    end
  end
end
