class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :name, :null => false
      t.integer :location_id

      t.timestamps
    end

    execute "ALTER TABLE communities 
                     ADD CONSTRAINT fk_communities_location_id
                        FOREIGN KEY (location_id) 
                         REFERENCES locations(id)"
  end

  def self.down
    drop_table :communities
  end
end
