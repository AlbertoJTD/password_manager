require "test_helper"

class Passwords::SharesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password = passwords(:example)
    @owner = users(:joe_doe)
    @viewer = users(:jane_doe)
  end

  test 'should not get new if user is not logged in' do
    get new_password_share_path(password_id: @password.id)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should get new if user is logged in and shareable' do
    create_user_password(@owner, :owner)

    sign_in @owner
    get new_password_share_path(password_id: @password.id)
    assert_response :success
  end

  test 'should not get new if user is logged in and not shareable' do
    create_user_password(@owner, :viewer)

    sign_in @owner
    get new_password_share_path(password_id: @password.id)
    assert_response :redirect
    assert_redirected_to password_path(id: @password.id)
  end

  test 'should not destroy if user is not logged in' do
    create_user_password(@owner, :viewer)

    delete password_share_path(password_id: @password.id, id: @owner.id)
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test 'should destroy if user is logged in and shareable' do
    create_user_password(@owner, :owner)
    create_user_password(@viewer, :viewer)

    sign_in @owner
    delete password_share_path(password_id: @password.id, id: @viewer.id)
    assert_response :redirect
    assert_redirected_to password_path(id: @password.id)
    assert_equal I18n.t('passwords.shares.sharing.removed_successfully'), flash[:notice]
  end

  test 'should not destroy if user is not added to the user_password' do
    create_user_password(@owner, :owner)
    create_user_password(@viewer, :viewer)

    sign_in @owner
    delete password_share_path(password_id: @password.id, id: 999)
    assert_response :redirect
    assert_redirected_to password_path(id: @password.id)
    assert_equal I18n.t('passwords.shares.sharing.not_found'), flash[:alert]
  end

  private

  def create_user_password(user, role)
    user_password = @password.user_passwords.find_or_initialize_by(user: user)
    user_password.role = role
    user_password.save!
  end
end
