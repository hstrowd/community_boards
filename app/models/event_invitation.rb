class EventInvitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  belongs_to :event
  has_many :emails, :class_name => 'EventInvitationEmail'
  has_many :recipients, 
          :through => :emails,
          :class_name => 'User',
          :foreign_key => 'user_id'

  validates_presence_of :event, :sender, :subject, :body

  # Creates an invitation for the provided event, sender, subject, and body. Calls send on that 
  # invitation passing it the email_addresses provided.
  #
  # Parameters:
  # * [event]: The Event model being invited to.
  # * [sender]: The User model responsible for sending the event.
  # * [subject]: The subject to be used in the email invitation.
  # * [body]: The body to be used in the email invitation.
  # * [email_addresses]: An Array of EmailAddress models to whom this invitation should be
  #                      sent.
  # Return:
  # * See #send_to
  def self.send_invitation(event, sender, subject, body, email_addresses = [])
    if(event.event_series.planners.include?(sender))
      if(!subject.empty? && !body.empty?)
        invitation = new(:event => event, :sender => sender, :subject => subject, :body => body)
        invitation.save!
      
        invitation.send_to(email_addresses)
      else
        logger.warn("User #{sender.id} attempted to send invitations for event #{event.id} with an empty subject (#{subject}) or body (#{body}).")
        nil
      end
    else
      logger.warn("User #{sender.id} attempted to send invitations for event #{event.id}, but is not a planner for that event.")
      nil
    end
  end

  # Sends the current invitation to each email address in the provided array. For each email
  # address that corresponds to a User, that user will become a tentative attendee of the 
  # event.
  #
  # Parameters:
  # * [email_addresses]: An Array of EmailAddress models to which this invitation should be
  #                      sent.
  # Return:
  # * [results]: A hash whose keys are the EmailAddresses provided and whose values are either
  #              the Email object created, or a symbol indicating the error encountered.
  def send_to(email_addresses)
    results = {}
    email_addresses.each do |email_address|
      # Check that this user/email has not been invited to this event within the last day.
      if email_address.user
        invitation_email = EventInvitationEmail.find_all_by_event_and_recipient(event, email_address.user).first
        already_sent_today = (invitation_email && invitation_email.created_at < 1.day.ago)
      else
        emails_sent_today = EventInvitationEmail.find(:all, :conditions => ['email_id = ? and created_at > ?', 
                                                                                 email_address, 1.day.ago])
        already_sent_today = (emails_sent_today.detect { |email| email.invitation.event.eql?(event) } && true)
      end

      if(!already_sent_today)
        email = EventInvitationEmail.new(:invitation => self, 
                                         :email => email_address)
        email.save!

        # If a user exists for this email, create a tentative attendance for this event.
        if((user = email_address.user) && !event.attendees.include?(user))
          event.add_attendee(user, EventAttendanceStatus.unknown)
        end

        results[email_address] = email
      else
        logger.info("Request made to send invitation #{self.id} to email #{email_address.email}, but this invitation has already been sent in the last day.")
        results[email_address] = :already_sent_today
      end
    end

    results
  end
end
