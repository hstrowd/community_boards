class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    render :action => 'index'
  end

  def authenticate
    if params[:login]
      # Find records with this username and password
      user = User.find(:first,
                       :conditions => [ "email = ? and password = ?", 
                                        params[:login][:email], 
                                        params[:login][:password] ])
 
      # Check whether this user exists or not
      if user
        # Create a session with users id
        session[:user_id] = user.id
        redirect_to :controller => 'users', :action => 'home', :id => user.id
      else
        flash[:notice] = "Invalid User/Password"
        redirect_to :action => 'index'
      end
    else
      flash[:notice] = "Login credentials required to log in."
      redirect_to :action => 'index'
    end
  end

  def logout
    if session[:user_id]
        reset_session
        redirect_to :action=> 'index'
    end
  end
end
