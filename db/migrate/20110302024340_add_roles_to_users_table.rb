class AddRolesToUsersTable < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      add_column :users, :role_id, :integer, :null => false

      execute "ALTER TABLE users 
                       ADD CONSTRAINT fk_users_role_id 
                          FOREIGN KEY (role_id) 
                           REFERENCES roles(id)"

      User.new({ :email => 'admin@commboards.com', 
                 :password => 'admin1', 
                 :role_id => 1 }).save!
    end
  end

  def self.down
    admin_user = User.find_by_email_and_password('admin@commboards.com', 'admin1')
    admin_user && admin_user.destroy

    execute "ALTER TABLE users DROP FOREIGN KEY fk_users_role_id"
    
    remove_column :users, :role_id
  end
end
