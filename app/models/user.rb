class User < ActiveRecord::Base
  belongs_to :primary_email, :class_name => 'EmailAddress'
  has_many :emails, :class_name => 'EmailAddress'

  belongs_to :permission
  belongs_to :visibility, :class_name => 'UserVisibility'

  belongs_to :location

  has_many :community_members, :dependent => :destroy
  has_many :communities, :through => :community_members

  has_many :event_attendances, :dependent => :destroy
  has_many :events, :through => :event_attendances
  # TODO: Update this dependancy to remove the user_id if the user is destroyed.
  has_many :event_invitations
  
  has_many :friendships_as_initiator, 
           :foreign_key => 'initiator_id', 
           :class_name => 'Friendship',
           :dependent => :destroy
  has_many :initiated_friends, 
           :through => :friendships_as_initiator,
           :class_name => 'User',
           :source => :recipient

  has_many :friendships_as_recipient, 
           :class_name => 'Friendship',
           :foreign_key => 'recipient_id', 
           :dependent => :destroy
  has_many :received_friends, 
           :through => :friendships_as_recipient,
           :class_name => 'User',
           :source => :initiator

  validates_presence_of :username, :password, :primary_email, :permission, :visibility
  validates_format_of :password, :with => /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,20}$/

  after_save do |user|
    user.primary_email.user = user
    user.primary_email.save!
  end

  def friends 
    (initiated_friends + received_friends)
  end

  def friendships
    (friendships_as_initiator + friendships_as_recipient)
  end
end
