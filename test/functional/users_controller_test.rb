require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @unique_seed = generate_test_seed
  end

  test "should authenticate users" do
    existing_user = users(:one)

    # Should reject requests with an unknown username.
    credentials = {:username => 'unknownUser',
                   :password => 'myPassword1'}
    post(:authenticate, :login => credentials)
    assert_nil session[:user]
    assert_not_nil flash[:notice]
    assert_redirected_to login_users_path

    # Should reject requests with an invalid password.
    credentials = {:username => existing_user.username,
                   :password => 'invalidPassword'}
    post(:authenticate, :login => credentials)
    assert_nil session[:user]
    assert_not_nil flash[:notice]
    assert_redirected_to login_users_path

    # Should reject requests that don't provide credentials.
    post(:authenticate)
    assert_nil session[:user]
    assert_not_nil flash[:notice]
    assert_redirected_to login_users_path

    # Should login requests with valid credentials.
    flash[:notice] = nil
    credentials = {:username => existing_user.username,
                   :password => 'myPassword1'}
    post(:authenticate, :login => credentials)
    assert_not_nil session[:user]
    assert_nil flash[:notice]
    assert_redirected_to root_path
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
    assert assigns(:user).new_record?
  end

  test "should create user" do
    username_1 = "#{@unique_seed}.doe"
    email_1 = "#{@unique_seed}.doe@test.com"
    attributes = { :username => username_1,
                   :password => 'test1pass',
                   :password_confirmation => 'test1pass',
                   :full_name => "#{@unique_seed} Doe",
                   :primary_email => email_1 }

    # Should accept unique users.
    assert_nil(User.find_by_username(username_1))
    assert_nil(EmailAddress.find_by_email(email_1))
    assert_difference('User.count') do
      response = post :create, :user => attributes
      puts response.inspect
    end
    assert_not_nil(User.find_by_username(username_1))
    assert_not_nil(EmailAddress.find_by_email(email_1))

    assert_redirected_to root_path

    # Should reject duplicate usernames.
    email_2 = "#{@unique_seed}.test@test.com"
    attributes[:primary_email] = email_2
    assert_not_nil(User.find_by_username(username_1))
    assert_nil(EmailAddress.find_by_email(email_2))
    assert_no_difference('User.count') do
      response = post :create, :user => attributes
    end
    assert_not_nil(User.find_by_username(username_1))
    assert_not_nil(EmailAddress.find_by_email(email_2))
    assert_response :success

    # Should reject submissions with emails already registered to other users.
    username_2 = "#{@unique_seed}.smith"
    attributes[:username] = username_2
    attributes[:primary_email] = email_1
    assert_nil(User.find_by_username(username_2))
    assert_not_nil(EmailAddress.find_by_email(email_1))
    assert_no_difference('User.count') do
      response = post :create, :user => attributes
    end
    assert_nil(User.find_by_username(username_2))
    assert_not_nil(EmailAddress.find_by_email(email_1))
    assert_response :success
  end


  # test "should show user" do
  #   get :show, :id => @user.to_param
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, :id => @user.to_param
  #   assert_response :success
  # end

  # test "should update user" do
  #   put :update, :id => @user.to_param, :user => @user.attributes
  #   assert_redirected_to user_path(assigns(:user))
  # end

  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete :destroy, :id => @user.to_param
  #   end

  #   assert_redirected_to users_path
  # end
end
