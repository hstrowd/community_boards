class Community < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :owner, :class_name => 'Users'
  belongs_to :location
  has_many :users, :through => :community_members
  has_many :events
end
