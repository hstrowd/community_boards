class Event < ActiveRecord::Base
  belongs_to :community
  belongs_to :creator, :class_name => 'User'
  belongs_to :visibility, :class_name => 'EventVisibility'

  has_many :invitations, 
           :class_name => 'EventInvitation',
           :order => 'created_at DESC'

  has_many :attendances, :class_name => 'EventAttendance'
  has_many :attendees, 
           :class_name => 'User',
           :foreign_key => 'user_id',
           :through => :attendances,
           :source => :user

  has_many :event_planners
  has_many :planners, 
           :class_name => 'User',
           :foreign_key => 'user_id',
           :through => :event_planners,
           :source => :user

  validates_presence_of :title, :community, :creator
  # The set of planners must include the creator, so that they are able to add more planners.
  validates_each :planners do |model, attr, value|
    value.include?(model.creator)
  end

  # Adds a user to the set of planners for this event. Only other planners are able to 
  # appoint other planners.
  #
  # Parameters:
  # * [planner]: The User model to be added to the set of planners.
  # * [appointer]: The User model responsible for appointing this user as a planner.
  #
  # Return:
  # * [result]: True, if the planner was appointed. False/nil, if this action failed.
  def add_planner(planner, appointer)
    if(planners.include?(appointer))
      planner_record = EventPlanner.new(:event => self,
                                        :user => planner,
                                        :appointer => approinter)
      planner_record.save!
    else
      logger.warn("User #{appointer.id} attempted to appoint user #{planner.id} as a planner for event #{self.id}, but is not allowed.")
    end
  end

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
        if(visibility.eql?(EventVisibility.public))
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

end
