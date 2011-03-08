class EventHubController < ApplicationController
  include ApplicationHelper

  # Prevents the current action from running if the user is not logged in.
  def login_filter
    unless logged_in?
      flash[:notice] = "You must first log in."
      redirect_to :controller => 'application', :action => 'index' 
    end
  end  
end
