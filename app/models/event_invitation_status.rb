class EventInvitationStatus < ActiveRecord::Base
  validates_presence_of :name, :description

  Sent = 'sent'
  RespondedTo = 'responded_to'

  def self.sent
    find_by_name(Sent)
  end

  def self.responded_to
    find_by_name(RespondedTo)
  end
end
