class EventAttendanceStatus < ActiveRecord::Base
  Attending = 'attending'
  Tentative = 'tentative'
  NotAttending = 'not_attending'

  def self.attending
    find_by_name(Attending)
  end

  def self.tentative
    find_by_name(Tentative)
  end

  def self.not_attending
    find_by_name(NotAttending)
  end
end
