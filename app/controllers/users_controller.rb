class UsersController < ApplicationController
  before_filter :require_login, :except => [:new, :create, :login, :authenticate, :logout]

  def login
    respond_to do |format|
      format.html # login.html.erb
    end
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
        redirect_to :action => 'home', :id => user.id
      else
        flash[:notice] = "Invalid User/Password"
        redirect_to :action => 'login'
      end
    else
      flash[:notice] = "Login credentials required to log in."
      redirect_to :action => 'login'
    end
  end

  def logout
    if session[:user_id]
        reset_session
        redirect_to :controller => 'application', :action=> 'index'
    end
  end

  def home
    user_id = session[:user_id]
    @user = User.find_by_id(user_id)

    respond_to do |format|
      format.html # home.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  # Identifies if a user is currently logged in.
  def logged_in?
    session[:user_id]
  end

  # Prevents the current action from running if the user is not logged in.
  def require_login
    unless logged_in?
      flash[:notice] = "You must first log in."
      redirect_to :controller => 'application', :action => 'index' 
    end
  end
  private :require_login
end
