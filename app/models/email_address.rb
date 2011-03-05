class EmailAddress < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :email
  validates_format_of :email, 
                      :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/
end
