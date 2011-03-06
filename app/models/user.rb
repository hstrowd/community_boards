class User < ActiveRecord::Base
  belongs_to :primary_email, :class_name => 'EmailAddress'
  has_many :email_addresses, :class_name => 'EmailAddress'

  belongs_to :permission
  belongs_to :visibility, :class_name => 'UserVisibility'

  belongs_to :location

  has_many :community_members, :dependent => :destroy
  has_many :communities, :through => :community_members

  has_many :event_attendances, :dependent => :destroy
  has_many :events, :through => :event_attendances
  # TODO: Update this dependancy to remove the user_id if the user is destroyed.
  has_many :event_invitations
  
  has_many :friendships_as_initiator, 
           :foreign_key => 'initiator_id', 
           :class_name => 'Friendship',
           :dependent => :destroy
  has_many :initiated_friends, 
           :through => :friendships_as_initiator,
           :class_name => 'User',
           :source => :recipient

  has_many :friendships_as_recipient, 
           :class_name => 'Friendship',
           :foreign_key => 'recipient_id', 
           :dependent => :destroy
  has_many :received_friends, 
           :through => :friendships_as_recipient,
           :class_name => 'User',
           :source => :initiator

  validates_presence_of :username, :hashed_password, :salt, :full_name,
                        :permission, :visibility
  validates_uniqueness_of :username
  validates_length_of :username, :within => 3..20
  validates_format_of :username, :with => /^[A-Za-z0-9]+([-_.][A-Za-z0-9]+)*$/

  validates_each :primary_email, :password do |model, attr, value|
    case attr
    when :primary_email
      if(!value)
        model.errors.add(:email_address, 'was not provided.')
      elsif(!value.valid?)
        model.errors.add(:email_address, 'is not valid.')
      elsif(value.new_record?)
        model.errors.add(:email_address, 'was not provided.')
      elsif(value.user && !value.user.eql?(model))
        model.errors.add(:email_address, 'already regestered to an existing user. Perhaps, you should use the forgot password utility.')
      end
    when :password
      if(!value)
        if(!model.hashed_password)
          model.errors.add(attr, 'was not provided.')
        end
      elsif(!(value =~ /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,20}$/))
        model.errors.add(attr, 'did not meet the requirments.')
      elsif !value.eql?(model.password_confirmation)
        model.errors.add(attr, 'does not match the password confirmation.')
      end
    end
  end

  attr_protected :id, :salt
  attr_accessor :password, :password_confirmation

  after_save do |user|
    user.primary_email.user = user
    user.primary_email.save!
  end

  def friends 
    (initiated_friends + received_friends)
  end

  def friendships
    (friendships_as_initiator + friendships_as_recipient)
  end
  
  def password=(new_password)
    @password = new_password
    self.salt = User.random_string(10) if !self.salt
    self.hashed_password = User.encrypt(password, salt)
  end

  def reset_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    # TODO: Send email to this user, giving them their new password.
  end

  def self.random_string(length)
    # Generates a random string consisting of letters, numbers, and punctuation.
    letters = ("a".."z").to_a + ("A".."Z").to_a
    numbers = ("0".."9").to_a
    punctuation = (' '..'/').to_a + (':'..'@').to_a + ('['..'`').to_a + ('{'..'~').to_a
    all_characters = letters + numbers + punctuation
    random_characters = []
    random_characters << letters.sample
    random_characters << numbers.sample
    random_characters << punctuation.sample
    (length - 3).times { random_characters << all_characters.sample }
    random_characters.shuffle.join
  end

  def self.encrypt(text, salt)
    Digest::SHA1.hexdigest(text+salt)
  end

  def self.authenticate(username, password)
    # Find records with this username
    user = find_by_username(username)

    # Check whether this user exists and verify the provided password.
    if(user && user.hashed_password = User.encrypt(password, user.salt))
      user
    else
      nil
    end
  end
end
