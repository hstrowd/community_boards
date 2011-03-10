class Event < ActiveRecord::Base
  belongs_to :event_series

  has_many :invitations, 
           :class_name => 'EventInvitation',
           :order => 'created_at DESC'

  has_many :attendances, :class_name => 'EventAttendance'
  has_many :attendees, 
           :class_name => 'User',
           :foreign_key => 'user_id',
           :through => :attendances,
           :source => :user

  def self.import(creator, community, import_file)
    required_attrs = %w(title city)
    series_attrs = %w(title description visibility)
    event_attrs = %w(start_time end_time cost)

    data = import_file.read
#    logger.info("User #{creator.id} is uploading file #{import_file.inspect} which contains #{data}.")
    
    rows = CSV.parse(data)
    logger.info("This was broken into rows: #{rows.inspect}.")

    attributes = rows[0]
    logger.info("User #{creator.id} is attempting to upload data with headers: #{attributes.inspect}.")

    if((attributes & required_attrs).eql?(required_attrs))
      (rows.size - 1).times do |index|
        begin
          event_data = row[index]

          if(community.private? && !community.members.include?(creator))
            # If unathorized, skip this event.
            logger.warn("User #{creator.id} attempted to create events for community #{community.id}, but is not a member.")
            next
          end

          # Create the Series for this event.
          series_data = series_attrs.inject({}) do |attr, series_hash|
            attr_index = attributes.index(attr)
            series_hash[attr] = row[attr_index] if attr_index
            series_hash
          end
          series_data['visibility'] = Visibility.find_by_name(series_data['visibility']) if series_data['visibility']
          series_data['creator'] = creator

          unless(series = EventSeries.find(:first, :conditions => series_data))
            series = EventSeries.new(series_data)
            series.save!
          end

          # Create the event.
          event_data = event_attrs.inject({}) do |attr, event_hash|
            attr_index = attributes.index(attr)
            event_hash[attr] = row[attr_index] if attr_index
            event_hash
          end
          event_data['start_time'] = Time.rfc2822(event_data['start_time']) if event_data['start_time']
          event_data['end_time'] = Time.rfc2822(event_data['end_time']) if event_data['end_time']

          event = Event.new(event_data)
          event.save!
        rescue Exception => exp
          logger.warn("Error encountered during import of #{row.inspec}: #{exp.message}\n  Backtrace: #{exp.backtrace * "\n"}")
        end
      end
    else
      loogger.warn("User #{creator.id} uploaded file #{import_file.inspect} which had improper headers.\n  Uploaded Data: #{data}.")
    end

    # TODO: perform import
#    logger.info("User #{creator.id} is uploading file #{import_file.inspect} which contains #{data}.")
  end

  # TODO: Break down this method.
  # Adds a User to the list of attendees for this Event. An attendee can only be added to an
  # Event if:
  # 1. The Event is a public event, or
  # 2. The Event is a private event and the User has an invitation to that event.
  #
  # Parameters:
  # * [user]: The User model to be added as an attendee of this Event.
  # * [status]: The initial EventAttendanceStatus to be used for this attendee.
  #
  # Return:
  # * [result]: True, if the attendee was sucsessfully added. False/nil, if an error occured.
  def add_attendee(user, status)
    # Reload to ensure that our check for existing attendees works as expected.
    reload

    # Don't allow attendee's to be created with a not_attending status.
    if(!status.eql?(EventAttendanceStatus.not_attending))
      if(!attendees.include?(user))
        if(event_series.visibility.eql?(EventVisibility.public))
          # Add attendee to public event.
          attendance = EventAttendance.new(:user => user,
                                           :event => self,
                                           :status => status)
          attendance.save!
        else
          if(invitation_email = EventInvitationEmail.find_all_by_event_and_recipient(self, user).first)
            # Add invited attendee to private event.
            attendance = EventAttendance.new(:user => user,
                                             :event => self,
                                             :status => status,
                                             :invitation_email => invitation_email)
            attendance.save!

            if(!status.eql?(EventAttendanceStatus.unknown))
              # Update the invitation to indicate it has been responded to.
              invitation_email.status = EventInvitationStatus.responded_to
              invitation_email.save!
            end
          else
            logger.warn("User #{user.id} attempted to attend private event #{self.id} without an invitation.")
            nil
          end
        end
      else
        logger.warn("User #{user.id} attempted to attend event #{self.id}, but is already an attendee.")
        nil
      end
    else
      logger.warn("User #{user.id} attempted to create attendance record for event #{self.id} with status #{status.id}.")
      nil
    end
  end

  def has_start_time?
    !(start_time.eql?(start_time.to_date.to_time))
  end

  def date
    start_time.to_date
  end

  # The duration of this event instance in hours.
  def duration
    (start_time - end_time)/(60*60)
  end

  def to_s
    str = "#{event_series} - #{date.strftime('%m/%d/%y')}"
    str << " at #{start_time.strftime('%I:%M%p')}" if has_start_time?
  end
end
