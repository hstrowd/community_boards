class EventInvitationEmail < ActiveRecord::Base
  belongs_to :invitation, :class_name => 'EventInvitation'
  belongs_to :email, :class_name => 'EmailAddress'
  has_one :recipient, 
          :through => :email,
          :foreign_key => 'user_id', 
          :class_name => 'User'

  validates_presence_of :invitation, :email

  # TODO: Document me.
  def self.find_all_by_event_and_recipient(event, recipient)
    email_ids = recipient.email_addresses.collect { |email| email.id }
    EventInvitationEmail.find_by_sql("SELECT eie.* 
                                        FROM event_invitation_emails eie 
                                        JOIN event_invitations ei ON eie.invitation_id = ei.id 
                                       WHERE ei.event_id = #{event.id} 
                                         AND eie.email_id IN (#{email_ids.join(', ')})
                                       ORDER BY ei.created_at DESC")
  end
end
