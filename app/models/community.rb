class Community < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :owner, :class_name => 'Users'
  belongs_to :location
  belongs_to :type, :class_name => 'CommunityType'
  has_many :community_members, :dependent => :destroy
  has_many :users, :through => :community_members
  has_many :event_series, :dependent => :destroy
end
