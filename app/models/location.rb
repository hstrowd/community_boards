class Location < ActiveRecord::Base
  has_many :communities

  validates_presence_of :country_cd, :city
end
