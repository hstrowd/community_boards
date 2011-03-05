class CommunityRole < ActiveRecord::Base
  Creator = 'creator'
  Owner = 'owner'

  def self.creator
    find_by_name(Creator)
  end
  
  def self.owner
    find_by_name(Owner)
  end
end
