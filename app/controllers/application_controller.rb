class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    if session[:user_id] && @user = User.find_by_id(session[:user_id])
      render :action => 'home'
    else
      render :action => 'index'
    end
  end
end
