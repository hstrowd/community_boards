class UserVisibility < ActiveRecord::Base
  validates_presence_of :name, :description

  Public = 'public'
  FriendsOnly = 'friend_only'
  Private = 'private'

  def self.public
    find_by_name(Public)
  end

  def self.friends_only
    find_by_name(FriendsOnly)
  end

  def self.private
    find_by_name(Private)
  end
end
