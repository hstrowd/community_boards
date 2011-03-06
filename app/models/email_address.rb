class EmailAddress < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, 
                      :with => /^[A-Za-z0-9][A-Za-z0-9_-]*(\.[A-Za-z0-9_-]+)*@[A-Za-z0-9][A-Za-z0-9_-]*(\.[A-Za-z0-9_-]+)*\.[A-Za-z]{2,4}$/

  def to_s
    self.email
  end
end
