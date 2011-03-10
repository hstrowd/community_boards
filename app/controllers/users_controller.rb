class UsersController < EventHubController
  before_filter :login_filter, :except => [:new, :create, :login, :authenticate, :logout]

  def authenticate
    if(params[:login][:username] && params[:login][:password])
      # Authenticate the provided information
      if(user = User.authenticate(params[:login][:username], params[:login][:password]))
        # Create a session with users id
        session[:user] = user
        redirect_to :controller => 'application', :action => 'index'
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
    if logged_in?
      reset_session
    end
    redirect_to :controller => 'application', :action=> 'index'
  end

  def add_community
    user = session[:user]
    if(user == User.find_by_id(params[:id]))
      if(community = Community.find_by_id(params[:community]))
        # TODO: Look into setting a temporary community. (i.e. is only tied to the current session)
        user.communities << community
        if user.save
          redirect_to :controller => 'application', :action => 'index'
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => user.errors, :status => :unprocessable_entity }
        end
      else
        flash[:notice] = "The specified community could not be found. Please try again."
        redirect_to :controller => 'application', :action => 'index'
      end
    else
      flash[:notice] = "Must be logged in to set a community."
      redirect_to :controller => 'application', :action => 'index'
    end
  end

  # GET /users/
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  def create
    email_address = params[:user].delete(:primary_email)
    @user = User.new(params[:user])
    @user.visibility = UserVisibility.public
    @user.permission = Permission.user
    @user.primary_email = EmailAddress.find_or_create_by_email(email_address)

    respond_to do |format|
      if @user.save
        session[:user] = @user
        render :controller => 'application', :action => 'index'
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
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
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
