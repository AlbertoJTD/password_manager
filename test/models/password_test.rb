require "test_helper"

class PasswordTest < ActiveSupport::TestCase
  setup do
    @password = passwords(:example)
    @joe = users(:joe_doe)
    @jane = users(:jane_doe)
  end

  test '#editable_by? returns true for owner' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :owner)

    assert @password.editable_by?(@joe)
  end

  test '#editable_by? returns true for editor' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :editor)

    assert @password.editable_by?(@joe)
  end

  test '#editable_by? returns true for manager' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :manager)

    assert @password.editable_by?(@joe)
  end

  test '#editable_by? returns false for viewer' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :viewer)

    assert_not @password.editable_by?(@joe)
  end

  test '#editable_by? returns false when user has no relationship' do
    assert_nil @password.editable_by?(@jane)
  end

  test '#sharable_by? returns true for owner' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :owner)

    assert @password.sharable_by?(@joe)
  end

  test '#sharable_by? returns false for editor' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :editor)

    assert_not @password.sharable_by?(@joe)
  end

  test '#sharable_by? returns false for manager' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :manager)

    assert_not @password.sharable_by?(@joe)
  end

  test '#sharable_by? returns false for viewer' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :viewer)

    assert_not @password.sharable_by?(@joe)
  end

  test '#sharable_by? returns false when user has no relationship' do
    assert_nil @password.sharable_by?(@jane)
  end

  test '#deletable_by? returns true for owner' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :owner)

    assert @password.deletable_by?(@joe)
  end

  test '#deletable_by? returns false for editor' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :editor)

    assert_not @password.deletable_by?(@joe)
  end

  test '#deletable_by? returns false for manager' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :manager)

    assert_not @password.deletable_by?(@joe)
  end

  test '#deletable_by? returns false for viewer' do
    user_password = user_passwords(:joe_doe_example)
    user_password.update(role: :viewer)

    assert_not @password.deletable_by?(@joe)
  end

  test '#deletable_by? returns false when user has no relationship' do
    assert_nil @password.deletable_by?(@jane)
  end
end
