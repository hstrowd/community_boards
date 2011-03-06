require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should reject invalid usernames" do
    user = users(:one)
    %w(.john _john -john john&jill john@doe john. john_ john- john..doe john--doe 
       john__doe john-_doe j joeseph-johnson.smith).each do |username|
      user.username = username
      assert(!user.valid?, "#{username} should not be a valid username, but is being accepted.")
    end
  end

  test "should accept valid usernames" do
    user = users(:one)
    %w(1john john_doe john-doe john.doe john.doe.smith john_doe.smith john-doe.smith
       123.456).each do |username|
      user.username = username
      assert(user.valid?, "#{username} should be a valid username, but is being rejected.")
    end
  end

  test "should reject invalid passwords" do
    user = users(:one)
    %w(1 a A ! 12345 abcde !@$%^&* 123456 abcdef ABCDEF aBcDeF abc!@$ AbC!@$
       123!@$ test.pass 1aZ!@ really.loong.password).each do |password|
      user.password = password
      user.password_confirmation = user.password
      assert(!user.valid?, "#{password} should not be a valid password, but is being accepted.")
    end
  end

  test "should accept valid passwords" do
    user = users(:one)
    %w(123abc 1a!@$% %^&1Az 1a!"#$%&'()*+,-.'/\\ ":;<=>?@[]^`_{|}~A1 t..t`2).each do |password|
      user.password = password
      user.password_confirmation = user.password
      assert(user.valid?, "#{password} should be a valid password, but is being rejected.")
    end
  end

  test "random_password should always be valid" do
    user = users(:one)
    100.times do 
      user.password = User.random_string(8)
      user.password_confirmation = user.password
      assert(user.valid?, "#{user.password} should be a valid password, but is being rejected.")
    end
  end
end
