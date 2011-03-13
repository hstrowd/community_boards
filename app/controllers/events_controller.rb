require 'event_import'

class EventsController < EventHubController
  before_filter :login_filter, :except => [:show, :filter]

  # Used to filter the currently visible set of events.
  def filter
    logger.error("Got to the filter action with params: #{params.inspect}")
    if(params[:filter])
      @events = Event.find_by_filters(params[:filter])
    else
      flash[:notice] = 'A condition to filter on must be specified.'
      @events = Event.all
    end

    logger.debug("Showing #{@events.size} events.")

    render :partial => 'events/event_list', :locals => {:events => @events}, :layout => false
  end

  def import
    if(params[:community_id] && params[:import_file])
      community = Community.find_by_id(params[:community_id])

      if community
        EventImport.import(params[:import_file], community, session[:user])
        # TODO: validate the results
        flash[:notice] = "The provided events have been added to the #{community} community."
      else
        flash[:notice] = 'Unable to find the specified community.'
      end
    else
      flash[:notice] = 'Must specify both a file to import and the community to which these events should be imported.'
    end
    render import_form_events_path
  end

  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
