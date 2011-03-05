require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  setup do
    @user_1 = users(:one)
    @user_2 = users(:two)
  end

  test "should start with no friends" do
    assert_equal([], @user_1.friends)
    assert_equal([], @user_2.friends)
  end

  test "should find all friends" do
    friendship = Friendship.new(:initiator => @user_1, 
                                :recipient => @user_2, 
                                :status => FriendshipStatus.requested)
    friendship.save!
    assert_equal([@user_2], @user_1.friends)
    assert_equal([@user_1], @user_2.friends)

    friendship.status = FriendshipStatus.accepted
    friendship.save!
    assert_equal([@user_2], @user_1.friends)
    assert_equal([@user_1], @user_2.friends)

    friendship.status = FriendshipStatus.declined
    friendship.save!
    assert_equal([@user_2], @user_1.friends)
    assert_equal([@user_1], @user_2.friends)

    friendship.status = FriendshipStatus.broken
    friendship.save!
    assert_equal([@user_2], @user_1.friends)
    assert_equal([@user_1], @user_2.friends)
  end

  test "request_friend should create a requested friendship" do
    assert_equal([], @user_1.friends)
    assert_equal([], @user_2.friends)

    assert(Friendship.request_friend(@user_1, @user_2))
    friendship = Friendship.find_by_users(@user_1, @user_2)
    assert_equal(FriendshipStatus.requested, friendship.status)

    @user_1.reload
    @user_2.reload

    assert_equal([friendship], @user_1.friendships_as_initiator)
    assert_equal([], @user_1.friendships_as_recipient)
    assert_equal([], @user_2.friendships_as_initiator)
    assert_equal([friendship], @user_2.friendships_as_recipient)

    assert_equal([@user_2], @user_1.friends)
    assert_equal([@user_1], @user_2.friends)

    # Shouldn't be able to create a friendship for existing friends.
    assert_nil(Friendship.request_friend(@user_2, @user_1))

    Friendship.accept_friend(@user_2, @user_1)
    Friendship.break_friendship(@user_2, @user_1)
    friendship.reload
    assert_equal(FriendshipStatus.broken, friendship.status)

    # Should be able to re-request a broken friendship.
    assert(Friendship.request_friend(@user_1, @user_2))
    friendship.reload
    assert_equal(FriendshipStatus.requested, friendship.status)
  end

  test "accept_friend should set status to accepted" do
    # Shouldn't be able to accept a non-existent friendship.
    assert_nil(Friendship.accept_friend(@user_2, @user_1))

    Friendship.request_friend(@user_1, @user_2)    
    friendship = Friendship.find_by_users(@user_1, @user_2)

    @user_1.reload
    @user_2.reload

    assert(Friendship.accept_friend(@user_2, @user_1))
    friendship.reload
    assert_equal(FriendshipStatus.accepted, friendship.status)

    # Shouldn't be able to accept an already accepted friendship.
    assert_nil(Friendship.accept_friend(@user_2, @user_1))
  end

  test "decline_friend should set status to declined" do
    # Shouldn't be able to decline a non-existent friendship.
    assert_nil(Friendship.decline_friend(@user_2, @user_1))

    Friendship.request_friend(@user_1, @user_2)
    friendship = Friendship.find_by_users(@user_1, @user_2)

    @user_1.reload
    @user_2.reload

    assert(Friendship.decline_friend(@user_2, @user_1))
    friendship.reload
    assert_equal(FriendshipStatus.declined, friendship.status)

    # The requesting party should not be able to accept the friendship.
    assert_nil(Friendship.accept_friend(@user_1, @user_2))
    friendship.reload
    assert_equal(FriendshipStatus.declined, friendship.status)

    # The declining party should be able to later accept the friendship.
    assert(Friendship.accept_friend(@user_2, @user_1))
    friendship.reload
    assert_equal(FriendshipStatus.accepted, friendship.status)
  end

  test "break_friendship should set status to broken" do
    # Shouldn't be able to break a non-existent friendship.
    assert_nil(Friendship.break_friendship(@user_1, @user_2))

    Friendship.request_friend(@user_1, @user_2)
    friendship = Friendship.find_by_users(@user_1, @user_2)

    @user_1.reload
    @user_2.reload

    Friendship.decline_friend(@user_2, @user_1)
    friendship.reload
    assert_equal(FriendshipStatus.declined, friendship.status)

    # Shouldn't be able to break a declined friendship.
    assert_nil(Friendship.break_friendship(@user_1, @user_2))
    friendship.reload
    assert_equal(FriendshipStatus.declined, friendship.status)

    Friendship.accept_friend(@user_2, @user_1)
    friendship.reload
    assert_equal(FriendshipStatus.accepted, friendship.status)

    # Should be able to break an accepted friendship.
    assert(Friendship.break_friendship(@user_2, @user_1))
    friendship.reload
    assert_equal(FriendshipStatus.broken, friendship.status)

    # Shouldn't be able to break an already broken friendship.
    assert_nil(Friendship.break_friendship(@user_1, @user_2))
    friendship.reload
    assert_equal(FriendshipStatus.broken, friendship.status)
  end
end
