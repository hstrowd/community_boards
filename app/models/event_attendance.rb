class EventAttendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :status, :class_name => 'EventAttendanceStatus'
  belongs_to :invitation_email, :class_name => 'EventInvitationEmail'

  validates_presence_of :user, :event, :status

  # TODO: Document me.
  def self.find_by_event_and_attendee(event, attendee)
    event.attendances.detect do |attendance|
      attendance.user.eql?(attendee)
    end
  end
end
