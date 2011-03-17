require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test 'should require valid start and end times' do
    event = Event.new({ :series => event_series(:public),
                        :community => communities(:city),
                        :start_time => Time.now })
    # Allow start time without end time
    assert event.valid?, 'Events with only a start time should be valid.'

    # Don't allow end time without start time
    event.start_time = nil
    event.end_time = Time.now
    assert !event.valid?, 'Events with only an end time should not be valid.'

    # Don't allow end time before start time
    event.start_time = Time.now + 1.hour
    assert !event.valid?, 'Events whose end time preceeds its start time should not be valid.'
  end

  test 'should have associated images' do 
    assert !events(:with_images).images.empty?
    assert_equal events(:without_images).images, []
  end

  test 'should be taggable' do 
    assert_nil "Implement me!"
  end

  test 'find_by_filters for start/end dates' do
    start_date = '25-02-2011'.to_date
    end_date = '01-03-2011'.to_date
    filters = {:date => {:start => start_date, :end => end_date}}
    filtered_events = Event.find_by_filters(filters)
    assert_equal(filtered_events, Event.find(:all, :conditions => ['start_time BETWEEN ? AND ?',
                                                                   start_date, (end_date + 1)]))
  end

  test 'add_attendee to a public event' do
    public_event = events(:public)
    user = users(:user)

    # Should have no attendees to start with.
    assert_equal([], public_event.attendees)

    assert_equal(EventVisibility.public, public_event.series.visibility)

    # Should not be able to add an attendee with not_attending status.
    assert_nil(public_event.add_attendee(user, EventAttendanceStatus.not_attending))
    public_event.reload
    assert_equal([], public_event.attendees)

    # Should be able to add attendee to a public events.
    assert(public_event.add_attendee(user, EventAttendanceStatus.attending))
    public_event.reload
    attendance = EventAttendance.find_by_event_and_attendee(public_event, user)
    assert_equal([attendance], public_event.attendances)
    assert_equal([user], public_event.attendees)
    assert_equal(EventAttendanceStatus.attending, attendance.status)

    # Should not be able to add a user that is already attending the event.
    assert_nil(public_event.add_attendee(user, EventAttendanceStatus.tentative))
    assert_equal(1, public_event.attendances.size)
  end

  test 'add_attendee to private event' do
    private_event = events(:private)
    user = users(:user)
    inviter = users(:private_event_planner)

    # Should have no attendees to start with.
    assert_equal([], private_event.attendees)

    invitation_email = EventInvitationEmail.find_all_by_event_and_recipient(private_event, user).first
    assert_nil(invitation_email)

    # Should not be able to add attendee to a private event without an invitation.
    assert_nil(private_event.add_attendee(user, EventAttendanceStatus.attending))
    private_event.reload
    attendance = EventAttendance.find_by_event_and_attendee(private_event, user)
    assert_nil(attendance)
    assert_equal([], private_event.attendees)

    EventInvitation.send_invitation(private_event, inviter, 'Invitation', 'You\'re invited', [user.primary_email])
    invitation_email = EventInvitationEmail.find_all_by_event_and_recipient(private_event, user).first
    assert_not_nil(invitation_email)
    private_event.reload

    # Inviting a user should add them as an attendee.
    attendance = EventAttendance.find_by_event_and_attendee(private_event, user)
    assert_equal(EventAttendanceStatus.unknown, attendance.status)
    assert_equal([user], private_event.attendees)
  end
end
