class CommunityType < ActiveRecord::Base
  Public = 'public'
  Private = 'private'

  def self.public
    find_by_name(Public)
  end

  def self.private
    find_by_name(Private)
  end
end
