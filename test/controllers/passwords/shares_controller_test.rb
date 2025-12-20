require "test_helper"

class Passwords::SharesControllerTest < ActionDispatch::IntegrationTest
  test 'should not get new if user is not logged in' do
    password = passwords(:example)
    get new_password_share_path(password_id: password.id)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get new if user is logged in and shareable' do
    user = users(:joe_doe)
    password = passwords(:example)
    user_password = password.user_passwords.find_or_initialize_by(user: user)
    user_password.role = :owner
    user_password.save!

    sign_in user
    get new_password_share_path(password_id: password.id)
    assert_response :success
  end

  test 'should not get new if user is logged in and not shareable' do
    user = users(:joe_doe)
    password = passwords(:example)
    user_password = password.user_passwords.find_or_initialize_by(user: user)
    user_password.role = :viewer
    user_password.save!

    sign_in user
    get new_password_share_path(password_id: password.id)
    assert_response :redirect
    assert_redirected_to password_path(id: password.id)
  end

  test 'should not destroy if user is not logged in' do
    password = passwords(:example)
    user = users(:joe_doe)
    user_password = password.user_passwords.find_or_initialize_by(user: user)
    user_password.role = :viewer
    user_password.save!

    # params[:id] should be the user_id
    delete password_share_path(password_id: password.id, id: user.id)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should destroy if user is logged in and shareable' do
    password = passwords(:example)
    joe_doe_user = users(:joe_doe)
    user_password = password.user_passwords.find_or_initialize_by(user: joe_doe_user)
    user_password.role = :owner
    user_password.save!

    jane_doe_user = users(:jane_doe)
    jane_doe_user_password = password.user_passwords.find_or_initialize_by(user: jane_doe_user)
    jane_doe_user_password.role = :viewer
    jane_doe_user_password.save!

    sign_in joe_doe_user

    # params[:id] should be the user_id of the user whose share we want to remove
    delete password_share_path(password_id: password.id, id: jane_doe_user.id)
    assert_response :redirect
    assert_redirected_to password_path(id: password.id)
    assert_equal I18n.t('passwords.shares.sharing.removed_successfully'), flash[:notice]
  end

  test 'should not destroy if user is not added to the user_password' do
    password = passwords(:example)
    joe_doe_user = users(:joe_doe)
    user_password = password.user_passwords.find_or_initialize_by(user: joe_doe_user)
    user_password.role = :owner
    user_password.save!

    jane_doe_user = users(:jane_doe)
    jane_doe_user_password = password.user_passwords.find_or_initialize_by(user: jane_doe_user)
    jane_doe_user_password.role = :viewer
    jane_doe_user_password.save!

    sign_in joe_doe_user

    # params[:id] should be the user_id of the user whose share we want to remove
    delete password_share_path(password_id: password.id, id: 1)
    assert_response :redirect
    assert_redirected_to password_path(id: password.id)
    assert_equal I18n.t('passwords.shares.sharing.not_found'), flash[:alert]
  end
end
