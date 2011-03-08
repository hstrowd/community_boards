class UsersController < EventHubController
  before_filter :login_filter, :except => [:new, :create, :login, :authenticate, :logout]

  def authenticate
    if(params[:login][:username] && params[:login][:password])
      # Authenticate the provided information
      if(user = User.authenticate(params[:login][:username], params[:login][:password]))
        # Create a session with users id
        session[:user_id] = user.id
        session[:user] = user
        redirect_to 'application/index'
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

  def set_location
    @user = User.find_by_id(params[:id])
    if(session[:user] == @user)
      if(location = Location.find_by_id(params[:location]))
        # TODO: Look into setting a temporary location. (i.e. is only tied to the current session)
        @user.location = location
        @user.save!
        render 'application/home'
      else
        flash[:notice] = "The specified location could not be found. Please try again."
        render 'application/home'
      end
    else
      flash[:notice] = "Must be logged in to set a location."
      render 'application/home'
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
    email_address = params[:user].delete(:primary_email)
    @user = User.new(params[:user])
    @user.visibility = UserVisibility.public
    @user.permission = Permission.user
    @user.primary_email = EmailAddress.find_or_create_by_email(email_address)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
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
end
