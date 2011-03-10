class CitiesController < CommunitiesController

  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city }
    end
  end

  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  def create
    location = Location.find_or_create(Location.correct_case(params[:location]))
    @city = City.new({ :name => location.to_s, 
                       :location => location, 
                       :visibility => CommunityVisibility.public })

    respond_to do |format|
      if @city.save
        format.html { redirect_to(@city, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        # TODO: Fix the validation message in this scenario.
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end
end
