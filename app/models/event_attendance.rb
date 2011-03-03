class EventAttendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :status, :class_name => 'EventAttendanceStatus'
end
