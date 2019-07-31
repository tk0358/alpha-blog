require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest

  test "get signup form and create user" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {username: "ruru", email: "ruru@example.com", password: "password" }}
      follow_redirect!
    end
    assert_template 'users/show'
    assert_match "ruru", response.body
  end

  test "invalid user submission results in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, params: {user: {username: "ru", email: "ruru@example.com", password: "password" }}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end