class Event < ActiveRecord::Base
  validates_presence_of :title, :community_id

  belongs_to :community
  has_many :users, :through => :event_attendances
end
