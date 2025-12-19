require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to login page if user is not logged in' do
    get passwords_path
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get index if user is logged in' do
    sign_in users(:joe_doe)
    get passwords_path
    assert_response :success
  end

  test 'should not get new if user is not logged in' do
    get new_password_path
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get new if user is logged in' do
    sign_in users(:joe_doe)
    get new_password_path
    assert_response :success
  end

  test 'should create password if user is logged in' do
    sign_in users(:joe_doe)

    password_params = {
      password: {
        service: 'Test Service',
        url: 'https://test.com',
        username: 'testuser',
        password: 'testpassword'
      }
    }

    assert_difference 'Password.count' do
      post passwords_path(format: :turbo_stream), params: password_params
    end

    assert_response :success
  end

  test 'should not show password if user is not logged in' do
    user = users(:joe_doe)
    # sign_in user

    password = passwords(:example)
    password.user_passwords.create(user: user, role: :owner)

    get password_path(id: password.id)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should show password if user is logged in' do
    user = users(:joe_doe)
    sign_in user

    password = passwords(:example)
    password.user_passwords.create(user: user, role: :owner)

    get password_path(id: password.id)
    assert_response :success
  end

  test 'should not edit password if user is not logged in' do
    user = users(:joe_doe)
    password = passwords(:example)
    password.user_passwords.create(user: user, role: :owner)

    get edit_password_path(id: password.id)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should edit password if user is logged in and current_user_password is editable' do
    user = users(:joe_doe)
    password = passwords(:example)

    %i[owner editor manager].each do |role|
      # Find or create user_password and ensure it has owner role
      user_password = password.user_passwords.find_or_initialize_by(user: user)
      user_password.role = role
      user_password.save!

      sign_in user
      get edit_password_path(id: password.id)

      assert_response :success
    end
  end

  test 'should not allow edit if current_user_password is not editable (viewer)' do
    user = users(:joe_doe)
    password = passwords(:example)

    # Find or create user_password and ensure it has owner role
    user_password = password.user_passwords.find_or_initialize_by(user: user)
    user_password.role = :viewer
    user_password.save!

    sign_in user
    get edit_password_path(id: password.id)

    assert_response :redirect
    assert_redirected_to password_path(id: password.id)
    assert_equal I18n.t('passwords.not_authorized_edit'), flash[:alert]
  end

  test 'should update password if user is logged in and current_user_password is editable' do
    user = users(:joe_doe)
    password = passwords(:example)

    %i[owner editor manager].each do |role|
      # Find or create user_password and ensure it has owner role
      user_password = password.user_passwords.find_or_initialize_by(user: user)
      user_password.role = role
      user_password.save!

      sign_in user
      patch password_path(id: password.id), params: { password: { service: 'Updated Service' } }

      assert_response :redirect
      assert_redirected_to password_path(id: password.id)
      assert_equal I18n.t('passwords.updated'), flash[:notice]
    end
  end

  test 'should not allow update if current_user_password is not editable (viewer)' do
    user = users(:joe_doe)
    password = passwords(:example)

    # Find or create user_password and ensure it has owner role
    user_password = password.user_passwords.find_or_initialize_by(user: user)
    user_password.role = :viewer
    user_password.save!

    sign_in user
    patch password_path(id: password.id), params: { password: { service: 'Updated Service' } }

    assert_response :redirect
    assert_redirected_to password_path(id: password.id)
    assert_equal I18n.t('passwords.not_authorized_edit'), flash[:alert]
  end

  test 'should destroy password if user is logged is owner' do
    user = users(:joe_doe)
    password = passwords(:example)

    # Find or create user_password and ensure it has owner role
    user_password = password.user_passwords.find_or_initialize_by(user: user)
    user_password.role = :owner
    user_password.save!

    sign_in user
    delete password_path(id: password.id)

    assert_response :redirect
    assert_redirected_to root_path
    assert_equal I18n.t('passwords.deleted'), flash[:notice]
  end

  test 'should not destroy password if user is logged in and current_user_password is not deletable' do
    user = users(:joe_doe)
    password = passwords(:example)

    %i[editor manager viewer].each do |role|
      # Find or create user_password and ensure it has owner role
      user_password = password.user_passwords.find_or_initialize_by(user: user)
      user_password.role = role
      user_password.save!

      sign_in user
      delete password_path(id: password.id)

      assert_response :redirect
      assert_redirected_to password_path(id: password.id)
      assert_equal I18n.t('passwords.not_authorized_delete'), flash[:alert]
    end
  end
end
