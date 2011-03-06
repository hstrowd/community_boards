module UsersHelper
  # Identifies if a user is currently logged in.
  def logged_in?
    session[:user_id]
  end
end
