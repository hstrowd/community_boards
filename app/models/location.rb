class Location < ActiveRecord::Base
  has_many :communities
  has_many :users

  validates_presence_of :country_cd, :city

  def self.correct_case(attributes)
    attributes['city'] = attributes['city'].downcase.titleize if attributes['city']
    attributes['state_cd'].upcase! if attributes['state_cd']
    attributes['country_cd'].upcase! if attributes['country_cd']
    attributes
  end

  def self.find_or_create(attributes)
    if(!attributes['state_cd'].blank?)
      location = find_by_city_and_state_cd_and_country_cd(attributes['city'], 
                                                          attributes['state_cd'], 
                                                          attributes['country_cd'])
    else
      location = find_by_city_and_country_cd(attributes['city'], attributes['country_cd'])
    end


    location = Location.new(attributes) if(!location)

    location
  end

  def to_s(include_country=false)
    str = city.dup
    if state_cd
      str << ", #{state_cd}"
    end
    if include_country
      str << ", #{country_cd}"
    end
    str
  end
end
