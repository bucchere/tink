require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { invited_by: @user.invited_by, mobile: @user.mobile, name: @user.name, next_ask: @user.next_ask, oauth_expires_at: @user.oauth_expires_at, oauth_token: @user.oauth_token, provider: @user.provider, uid: @user.uid } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { invited_by: @user.invited_by, mobile: @user.mobile, name: @user.name, next_ask: @user.next_ask, oauth_expires_at: @user.oauth_expires_at, oauth_token: @user.oauth_token, provider: @user.provider, uid: @user.uid } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end