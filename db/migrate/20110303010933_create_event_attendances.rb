require 'migration_helper'
class CreateEventAttendances < ActiveRecord::Migration
  extend MigrationHelper
  def self.up
    create_table :event_attendance_statuses do |t|
      t.string :name, :null => false
      t.string :description, :null => false
    end

    EventAttendanceStatus.new(:name => EventAttendanceStatus::Attending, 
                              :description => 'The user will be attending this event.').save!
    EventAttendanceStatus.new(:name => EventAttendanceStatus::Tentative, 
                              :description => 'The user may or may not be attending this event.').save!
    EventAttendanceStatus.new(:name => EventAttendanceStatus::NotAttending, 
                              :description => 'The user will not be attending this event.').save!
    EventAttendanceStatus.new(:name => EventAttendanceStatus::Unknown, 
                              :description => 'The user has been invited, but has not yet reponded.').save!

    create_table :event_invitations do |t|
      t.integer :sender_id, :null => false
      t.integer :event_id, :null => false
      t.text :subject, :null => false
      t.text :body, :null => false

      t.timestamps
    end

    add_foreign_key 'event_invitations', 'sender_id', 'users'
    add_foreign_key 'event_invitations', 'event_id', 'events'


    create_table :event_invitation_emails do |t|
      t.integer :invitation_id, :null => false
      t.integer :email_id, :null => false

      t.timestamps
    end

    add_foreign_key 'event_invitation_emails', 'invitation_id', 'event_invitations'
    add_foreign_key 'event_invitation_emails', 'email_id', 'email_addresses'


    create_table :event_attendances do |t|
      t.integer :user_id, :null => false
      t.integer :event_id, :null => false
      t.integer :status_id, :null => false
      t.integer :invitation_id

      t.timestamps
    end

    add_foreign_key 'event_attendances', 'user_id', 'users'
    add_foreign_key 'event_attendances', 'event_id', 'events'
    add_foreign_key 'event_attendances', 'status_id', 'event_attendance_statuses'
    add_foreign_key 'event_attendances', 'invitation_id', 'event_invitations'
  end

  def self.down
    drop_table :event_attendances
    drop_table :event_attendance_statuses
  end
end
