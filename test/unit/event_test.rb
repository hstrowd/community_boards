require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @public_event = events(:one_one)
    @private_event = events(:two_one)
    @user = users(:one)
    @inviter = users(:two)
  end

  # Replace this with your real tests.
  test 'add_attendee to a public event' do
    # Should have no attendees to start with.
    assert_equal([], @public_event.attendees)

    assert_equal(EventVisibility.public, @public_event.event_series.visibility)

    # Should not be able to add an attendee with not_attending status.
    assert_nil(@public_event.add_attendee(@user, EventAttendanceStatus.not_attending))
    @public_event.reload
    assert_equal([], @public_event.attendees)

    # Should be able to add attendee to a public events.
    assert(@public_event.add_attendee(@user, EventAttendanceStatus.attending))
    @public_event.reload
    attendance = EventAttendance.find_by_event_and_attendee(@public_event, @user)
    assert_equal([attendance], @public_event.attendances)
    assert_equal([@user], @public_event.attendees)
    assert_equal(EventAttendanceStatus.attending, attendance.status)

    # Should not be able to add a user that is already attending the event.
    assert_nil(@public_event.add_attendee(@user, EventAttendanceStatus.tentative))
    assert_equal(1, @public_event.attendances.size)
  end

  test 'add_attendee to private event' do
    # Should have no attendees to start with.
    assert_equal([], @private_event.attendees)

    invitation_email = EventInvitationEmail.find_all_by_event_and_recipient(@private_event, @user).first
    assert_nil(invitation_email)

    # Should not be able to add attendee to a private event without an invitation.
    assert_nil(@private_event.add_attendee(@user, EventAttendanceStatus.attending))
    @private_event.reload
    attendance = EventAttendance.find_by_event_and_attendee(@private_event, @user)
    assert_nil(attendance)
    assert_equal([], @private_event.attendees)

    EventInvitation.send_invitation(@private_event, @inviter, 'Invitation', 'You\'re invited', [@user.primary_email])
    invitation_email = EventInvitationEmail.find_all_by_event_and_recipient(@private_event, @user).first
    assert_not_nil(invitation_email)
    @private_event.reload

    # Inviting a user should add them as an attendee.
    attendance = EventAttendance.find_by_event_and_attendee(@private_event, @user)
    assert_equal(EventAttendanceStatus.unknown, attendance.status)
    assert_equal([@user], @private_event.attendees)
  end
end
