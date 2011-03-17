class Image < ActiveRecord::Base
  validates_presence_of :source
end
