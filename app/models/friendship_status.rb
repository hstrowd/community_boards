class FriendshipStatus < ActiveRecord::Base
  Requested = 'requested'
  Accepted = 'accepted'
  Declined = 'declined'
  Broken = 'broken'

  def self.requested
    find_by_name(Requested)
  end

  def self.accepted
    find_by_name(Accepted)
  end

  def self.declined
    find_by_name(Declined)
  end

  def self.broken
    find_by_name(Broken)
  end
end
