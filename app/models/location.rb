class Location < ActiveRecord::Base
  has_many :communities
  has_many :users

  validates_presence_of :country_cd, :city

  def before_save
    self.country_cd.upcase!
    self.state_cd.upcase!
    self.city = self.city.humanize.titleize
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
