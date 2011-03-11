class Community < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :location
  belongs_to :visibility, :class_name => 'CommunityVisibility'
  has_many :community_members, :dependent => :destroy
  has_many :members, :through => :community_members, :class_name => 'User'
  has_many :events, :dependent => :destroy

  validates_presence_of :name
  validates_inclusion_of :type, :in => %w(City)

  def public?
    visibility.eql?(CommunityVisibility.public)
  end

  def private?
    visibility.eql?(CommunityVisibility.private)
  end
end
