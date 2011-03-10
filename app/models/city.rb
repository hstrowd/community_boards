class City < Community
  validates_presence_of :location
  validates_uniqueness_of :location_id
  validates_associated :location

  def to_s
    location.to_s
  end
end
