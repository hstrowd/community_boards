class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title, :null => false
      t.text :description, :null => false
      t.integer :community_id, :null => false
      t.datetime :start_time
      t.datetime :end_time
      t.float :cost

      t.timestamps
    end

    execute "ALTER TABLE events 
                     ADD CONSTRAINT fk_events_community_id
                        FOREIGN KEY (community_id) 
                         REFERENCES communities(id)"
  end

  def self.down
    drop_table :events
  end
end
