class EventAttendanceStatus < ActiveRecord::Base
  validates_presence_of :name, :description

  Attending = 'attending'
  Tentative = 'tentative'
  NotAttending = 'not_attending'
  Unknown = 'unknown'

  def self.attending
    find_by_name(Attending)
  end

  def self.tentative
    find_by_name(Tentative)
  end

  def self.not_attending
    find_by_name(NotAttending)
  end

  def self.unknown
    find_by_name(Unknown)
  end
end
