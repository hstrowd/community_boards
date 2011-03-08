module ApplicationHelper
  def current_country_cd
    'USA'
  end

  # Identifies if a user is currently logged in.
  def logged_in?
    session[:user_id]
  end
end
