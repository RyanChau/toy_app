class User < ActiveRecord::Base

  # this is the before_save callback
  # before_save { self.email = self.email.downcase }
  before_save { self.email = email.downcase }
# Some database adapters use case-sensitive indices, considering the strings “Foo@ExAMPle.CoM” and “foo@example.com” to be distinct,
# but our application treats those addresses as the same.

  # validates(:name, {presence: true, length: { maximum: 50 }})
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
  validates :password, presence: true, length: { minimum: 6 }
end
