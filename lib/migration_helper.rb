module MigrationHelper
  def add_foreign_key(from_table, from_column, to_table)
    execute "ALTER TABLE #{from_table} 
                     ADD CONSTRAINT fk_#{from_table}_#{from_column} 
                        FOREIGN KEY (#{from_column}) 
                         REFERENCES #{to_table}(id)"
  end

  def drop_foreign_key(from_table, from_column)
    execute "ALTER TABLE #{from_table} DROP FOREIGN KEY fk_#{from_table}_#{from_column}"
  end
end
