class Location < ActiveRecord::Base
  has_many :communities
  has_many :users

  validates_presence_of :country_cd, :city

  before_save :correct_case

  def correct_case
    self.country_cd.upcase!
    self.state_cd.upcase!
    self.city.downcase!
  end

  def to_s(include_country=false)
    str = city
    if state_cd
      str << ", #{state_cd}"
    end
    if include_country
      str << ", #{country_cd}"
    end
    str
  end
end
