class Event < ActiveRecord::Base
  belongs_to :community

  validates_presence_of :title, :community_id
end
