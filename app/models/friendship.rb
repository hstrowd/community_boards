class Friendship < ActiveRecord::Base
  belongs_to :initiator, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :status, :class_name => 'FriendshipStatus'

  validates_presence_of :initiator, :recipient, :status
  validates_each :initiator do |model, attr, value|
    # Don't allow friendships with yourself.
    model.recipient != value
  end

  def self.find_by_users(user_1, user_2)
    where(:initiator_id => user_1.id, :recipient_id => user_2.id).first ||
      where(:initiator_id => user_2.id, :recipient_id => user_1.id).first
  end

  def self.request_friend(initiator, recipient)
    friendship = find_by_users(initiator, recipient)
    if !friendship
      new(:initiator => initiator, 
               :recipient => recipient, 
               :status => FriendshipStatus.requested).save!
    elsif friendship.status.eql?(FriendshipStatus.broken)
      friendship.status = FriendshipStatus.requested
      friendship.save!
    else
      logger.warn("User #{initiator.id} attempted to establish a friendship with #{recipient.id} but are already friends.")
      nil
    end
  end

  def self.accept_friend(acceptor, initiator)
    friendship = acceptor.friendships_as_recipient.detect { |f| f.initiator.eql?(initiator) }
    if friendship && (friendship.status.name.eql?(FriendshipStatus::Requested) ||
                      friendship.status.name.eql?(FriendshipStatus::Declined))
      friendship.status = FriendshipStatus.accepted
      friendship.save!
    else
      logger.warn("User #{acceptor.id} attempted to accept the friendship of #{initiator.id} but not a valid transition. Friendship: #{friendship.inspect}.")
      nil
    end
  end

  def self.decline_friend(decliner, initiator)
    friendship = decliner.friendships_as_recipient.detect { |f| f.initiator.eql?(initiator) }
    if friendship && friendship.status.name.eql?(FriendshipStatus::Requested)
      friendship.status = FriendshipStatus.declined
      friendship.save
    else
      logger.warn("User #{decliner.id} attempted to decline the friendship of #{initiator.id} but not a valid transition. Friendship: #{friendship.inspect}.")
      nil
    end
  end

  def self.break_friendship(breaker, ex_friend)
    friendship = find_by_users(breaker, ex_friend)
    if friendship && friendship.status.name.eql?(FriendshipStatus::Accepted)
      friendship.status = FriendshipStatus.broken
      friendship.save
    else
      logger.warn("User #{breaker.id} attempted to break their friendship with #{ex_friend.id} but not a valid transition. Friendship: #{friendship.inspect}.")
      nil
    end
  end

end
