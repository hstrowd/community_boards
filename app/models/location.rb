class Location < ActiveRecord::Base
  has_many :communities
  has_many :users

  validates_presence_of :country_cd, :city

  after_initialize :correct_case

  def self.find_or_create(attributes)
    if(!attributes['state_cd'].blank?)
      location = find_by_city_and_state_cd_and_country_cd(attributes['city'], 
                                                          attributes['state_cd'], 
                                                          attributes['country'])
    else
      attributes.delete('state_cd')
      location = find_by_city_and_country_cd(attributes)
    end


    location = Location.new(attributes) if(!location)

    location
  end

  def correct_case
    self.country_cd.upcase!
    self.state_cd.upcase!
    self.city = self.city.downcase.titleize
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
