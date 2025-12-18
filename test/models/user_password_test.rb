require "test_helper"

class UserPasswordTest < ActiveSupport::TestCase
  setup do
    @user_password = user_passwords(:joe_doe_example)
  end

  test '#editable? returns true if the user is the owner' do
    @user_password.role = :owner
    assert @user_password.editable?
  end

  test '#editable? returns true if the user is the editor' do
    @user_password.role = :editor
    assert @user_password.editable?
  end

  test '#editable? returns true if the user is the manager' do
    @user_password.role = :manager
    assert @user_password.editable?
  end

  test '#editable? returns false if the user is viewer' do
    @user_password.role = :viewer
    assert_not @user_password.editable?
  end

  test '#sharable? returns true if the user is the owner' do
    @user_password.role = :owner
    assert @user_password.sharable?
  end

  test '#sharable? returns false if the user is not the owner' do
    %i[editor manager viewer].each do |role|
      @user_password.role = role
      assert_not @user_password.sharable?
    end
  end

  test '#deletable? returns true if the user is the owner' do
    @user_password.role = :owner
    assert @user_password.deletable?
  end

  test '#deletable? returns false if the user is not the owner' do
    %i[editor manager viewer].each do |role|
      @user_password.role = role
      assert_not @user_password.deletable?
    end
  end

  test 'validates role presence' do
    @user_password.role = nil
    assert_not @user_password.valid?
    assert_equal "can't be blank", @user_password.errors[:role].first
  end

  test 'validates role inclusion' do
    UserPassword.roles.each_key do |role|
      @user_password.role = role
      assert @user_password.valid?
    end
  end
end
