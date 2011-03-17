class EventImage < ActiveRecord::Base
  belongs_to :event
  belongs_to :image

  validates_presence_of :event, :image
end
