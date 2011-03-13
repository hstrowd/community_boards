module ApplicationHelper
  def current_country_cd
    'USA'
  end

  def date_format
    '%m/%d/%Y'
  end

  # Identifies if a user is currently logged in.
  def logged_in?
    !session[:user].nil?
  end
end
