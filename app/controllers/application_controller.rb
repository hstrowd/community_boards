class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    @user = session[:user]
    render
  end
end
