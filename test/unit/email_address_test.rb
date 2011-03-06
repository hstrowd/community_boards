require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  test "should reject invalid email addresses" do
    email = EmailAddress.new
    %w(john john@example -john@example.com _john@example.com john!@example.com 
       john(smith)doe@example.com john+doe@example.com john%doe@example.com john.@example.com
       john&doe@example.com john@doe@example.com -john@example.com 
       john..@example.com john@_example.com john@-example.com john@..com john@example..com 
       john@example.commm john@example.c john@example.123 john@example.n_t).
      each do |email_address|
      email.email = email_address
      assert(!email.valid?, "#{email_address} should not be a valid email, but is being accepted.")
    end
  end

  test "should accept valid email addresses" do
    email = EmailAddress.new
    %w(j@example.com john@example.com john.doe@example.com j_d@example.com j-d@example.com 
       1_john@example.com john.-@example.com john_._@example.com john.1@example.com
       john@123.com john@1_example.com john@1_.example.com john@my.-.com john@example.co
       john@example.co.nz john@example.net john@example.info john@example.mobi).
      each do |email_address|
      email.email = email_address
      assert(email.valid?, "#{email_address} should be a valid email, but is being rejected.")
    end
  end
end
