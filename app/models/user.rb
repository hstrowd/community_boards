class User < ActiveRecord::Base
  belongs_to :permission
  belongs_to :visibility, :class_name => 'UserVisibility'

  belongs_to :location
  has_many :communities, :through => :community_members
  has_many :events, :through => :event_attendances

  has_many :friendships_as_initiator, 
           :class_name => 'Friendship',
           :foreign_key => 'initiator_id', 
           :dependent => :destroy
  has_many :initiated_friends, 
           :class_name => 'User',
           :through => :friendships_as_initiator,
           :source => :recipient

  has_many :friendships_as_recipient, 
           :class_name => 'Friendship',
           :foreign_key => 'recipient_id', 
           :dependent => :destroy
  has_many :received_friends, 
           :class_name => 'User',
           :through => :friendships_as_recipient,
           :source => :initiator

  validates_presence_of :email, :password, :permission, :visibility
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/
  validates_format_of :password, :with => /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,20}$/

  def friends 
    (initiated_friends + received_friends)
  end

  def friendships
    (friendships_as_initiator + friendships_as_recipient)
  end
end
