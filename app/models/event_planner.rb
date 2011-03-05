class EventPlanner < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :appointer, :class_name => 'User'

  validates_presence_of :user, :event
end
