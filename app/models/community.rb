class Community < ActiveRecord::Base
  belongs_to :location
  has_and_belongs_to_many :users
  has_many :events

  validates_presence_of :name
end
