require "application_system_test_case"

class Passwords::CreatePasswordsTest < ApplicationSystemTestCase
  setup do
    @user = users(:joe_doe)
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'password'
    click_on 'Log in'
  end

  test 'user creates a new password' do
    new_password = Password.new(
      service: Faker::Company.name,
      url: Faker::Internet.url,
      username: Faker::Internet.username,
      password: Faker::Internet.password
    )

    click_on 'New Password'
    assert_selector 'h1', text: 'New Password'

    fill_in 'Service', with: new_password.service
    fill_in 'URL', with: new_password.url
    fill_in 'Username', with: new_password.username
    fill_in 'Password', with: new_password.password
    click_on 'Save Password'

    # Verify the password info in the sidebar
    assert_selector 'span', text: new_password.url
    assert_selector 'code', text: new_password.username
    assert_selector 'code', text: new_password.password
  end

  test 'form shows validation errors when invalid data is submitted' do
    new_password = Password.new(
      service: '',
      url: '',
      username: '',
      password: ''
    )

    click_on 'New Password'
    assert_selector 'h1', text: 'New Password'

    fill_in 'Service', with: new_password.service
    fill_in 'URL', with: new_password.url
    fill_in 'Username', with: new_password.username
    fill_in 'Password', with: new_password.password
    click_on 'Save Password'

    # Verify the validation errors are displayed
    assert_selector 'div.mb-6.p-4.bg-red-50.border.border-red-200.rounded-lg'
    assert_selector 'h3', text: I18n.t('correct_errors')
    %w[Service Username Password].each do |field|
      assert_selector 'li', text: "#{field} can't be blank"
    end
    assert_no_selector 'li', text: "URL can't be blank"

    # Required input fields should have red borders
    %w[Service Username Password].each do |field|
      assert_selector "#password_#{field.downcase}.border-red-500.focus\\:ring-red-500.focus\\:border-red-500"
    end
  end

  test 'user opens and closes the password form modal' do
    click_on 'New Password'
    assert_selector 'h1', text: 'New Password'

    # Verify the modal is open
    assert_selector 'turbo-frame#modal h1', text: 'New Password'

    # Close the modal by clicking the close button
    find('button[data-action="click->shared--modal-component#close"]').click

    # Verify the modal is closed
    within 'turbo-frame#modal' do
      assert_no_selector '*'
    end
  end
end
