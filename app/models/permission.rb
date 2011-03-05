class Permission < ActiveRecord::Base
  Admin = 'admin'
  Regulator = 'regulator'
  User = 'user'

  def self.admin
    find_by_name(Admin)
  end

  def self.regulator
    find_by_name(Regulator)
  end

  def self.user
    find_by_name(User)
  end
end
