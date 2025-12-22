require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'redirects to sign in page after create a new user not confirmed' do
    initial_count = User.count

    post user_registration_path, params: {
      user: {
        email: 'newuser@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }

    assert_redirected_to new_user_session_path
    assert_equal initial_count + 1, User.count
    user = User.find_by(email: 'newuser@example.com')
    assert_not user.confirmed?
  end
end
