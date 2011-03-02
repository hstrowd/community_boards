class CreateLocations < ActiveRecord::Migration
  def self.up
    execute "CREATE TABLE locations ( id integer NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                      country_cd varchar(3) NOT NULL,
                                      state_cd varchar(5) NOT NULL,
                                      city varchar(255) NOT NULL,
                                      created_at datetime,
                                      updated_at datetime,
                                      INDEX (id) ) ENGINE=InnoDB"

    execute "ALTER TABLE locations 
                     ADD CONSTRAINT unique_contry_state_city
                             UNIQUE (country_cd, state_cd, city)"
  end

  def self.down
    drop_table :locations
  end
end
