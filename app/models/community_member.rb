class CommunityMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  belongs_to :role
end
