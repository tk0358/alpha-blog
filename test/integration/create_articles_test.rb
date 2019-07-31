require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username: "ruru", email: "ruru@example.com", password: "password")
  end

  test "should create a new article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params: {article: {title: "Ruru", description: "Ruru is sleeping"}}
      follow_redirect!
    end
    assert_template 'articles/show'
    assert_match "Ruru", response.body
  end

  test "invalid title results in failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params: {article: {title: "Ru", description: "Ruru is sleeping"}}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
end