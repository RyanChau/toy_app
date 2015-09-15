class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  #foo@bar.com is treated the same as FOO@BAR.COM or FoO@BAr.coM
  #=> so email should be unique with case-insensitive

  has_secure_password
  # When included in a model as above, the method has_secure_password adds the following functionality:
  #1/ The ability to save a securely hashed password_digest attribute to the database
  #2/ A pair of virtual attributes18 (password and password_confirmation), including presence validations upon object creation and a validation requiring that they match
  #3/ An authenticate method that returns the user when the password is correct (and false otherwise)

  # has_secure_password automatically adds an authenticate method to the corresponding model objects.
# This method determines if a given password is valid for a particular user by computing its digest and comparing the result to password_digest
# in the database

  # in order for the has_secure_method works, we need to add new column "password_digest" to database
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

# Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # the update_attribute method to update the remember digest. (this method bypasses the validations, which is necessary in this case because
  # we don’t have access to the user’s password or confirmation.)

  # Returns true if the given token matches the digest.
  # def authenticated?(remember_token)
  #   return false if remember_digest.nil?    # avoid the problem when using two browsers to logging and then one of them logging out
  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)
  end

  private
  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
