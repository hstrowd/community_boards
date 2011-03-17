require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  test "homepage should return only events, if user is not logged in" do
    session[:user] = nil

    get :index
    assert_response :success
    assert_not_nil assigns(:events)
    assert_nil assigns(:user)
  end

  test "homepage should return a user and events, if user is logged in" do
    session[:user] = users(:one)

    get :index
    assert_response :success
    assert_not_nil assigns(:events)
    assert_not_nil assigns(:user)
  end
end
