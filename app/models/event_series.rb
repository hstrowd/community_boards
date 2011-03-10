require 'csv'

class EventSeries < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :community
  belongs_to :creator, :class_name => 'User'
  belongs_to :visibility, :class_name => 'EventVisibility'

  has_many :events

  has_many :event_planners
  has_many :planners, 
           :class_name => 'User',
           :foreign_key => 'user_id',
           :through => :event_planners,
           :source => :user

  validates_presence_of :title, :community, :creator
  # The set of planners must include the creator, so that they are able to add more planners.
  validates_each :planners do |model, attr, value|
    value.include?(model.creator)
  end

  # Adds a user to the set of planners for this event. Only other planners are able to 
  # appoint other planners.
  #
  # Parameters:
  # * [planner]: The User model to be added to the set of planners.
  # * [appointer]: The User model responsible for appointing this user as a planner.
  #
  # Return:
  # * [result]: True, if the planner was appointed. False/nil, if this action failed.
  def add_planner(planner, appointer)
    if(planners.include?(appointer))
      planner_record = EventPlanner.new(:event_series => self,
                                        :user => planner,
                                        :appointer => approinter)
      planner_record.save!
    else
      logger.warn("User #{appointer.id} attempted to appoint user #{planner.id} as a planner for event #{self.id}, but is not allowed.")
    end
  end

  def to_s
    "#{title} in #{community.location}"
  end
end
