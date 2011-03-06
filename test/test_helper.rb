ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def generate_test_seed(length=5)
    letters = ("a".."z").to_a + ("A".."Z").to_a
    seed = []
    length.times { seed << letters.sample }
    seed.join
  end

  def new_user_attributes(base_user=users(:one))
    unique_seed = generate_test_seed

    attrs = base_user.attributes
    attrs['username'] = unique_seed + attrs['username']

    email_address = EmailAddress.new(:email => (unique_seed + base_user.primary_email.email))
    email_address.save!
    attrs['primary_email_id'] = email_address.id

    attrs
  end
end
