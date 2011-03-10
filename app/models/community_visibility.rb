class CommunityVisibility < ActiveRecord::Base
  validates_presence_of :name, :description

  Public = 'public'
  Private = 'private'

  def self.public
    find_by_name(Public)
  end

  def self.private
    find_by_name(Private)
  end
end
