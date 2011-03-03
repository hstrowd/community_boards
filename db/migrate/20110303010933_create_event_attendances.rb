require 'migration_helper'
class CreateEventAttendances < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :event_attendance_statuses do |t|
      t.string :status, :null => false
      t.string :description, :null => false
    end
    EventAttendanceStatus.new({ :status => 'attending', 
                                :description => 'The user will be attending this event.' })
    EventAttendanceStatus.new({ :status => 'tentative', 
                                :description => 'The user may or may not be attending this event.' })
    EventAttendanceStatus.new({ :status => 'not_attending', 
                                :description => 'The user will not be attending this event.' })

    create_table :event_attendances do |t|
      t.integer :user_id, :null => false
      t.integer :event_id, :null => false
      t.integer :status_id, :null => false

      t.timestamps
    end

    add_foreign_key 'event_attendances', 'user_id', 'users'
    add_foreign_key 'event_attendances', 'event_id', 'events'
    add_foreign_key 'event_attendances', 'status_id', 'event_attendance_statuses'
  end

  def self.down
    drop_table :event_attendances
    drop_table :event_attendance_statuses
  end
end
