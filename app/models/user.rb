# User model class
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :gestures
  has_many :reviews, foreign_key: :reviewer_id

  validates :city, :country, :date_of_birth, :first_name,
            :gender, :last_name, :type, presence: true
  validates :email, presence: true, uniqueness: true
  validate :type_is_valid_model_name
  validate :password_complexity

  def self.roles
    %w[Admin Reviewer User]
  end

  def password_complexity
    return if password =~ /^(?=.*?[a-zA-Z])(?=.*?[0-9]).{8,}$/ && password != email

    errors.add :password, :too_weak
  end

  def type_is_valid_model_name
    return if User.roles.include?(type)

    errors.add(:type, 'Type must be a a valid User class or subclass')
  end

  # Convenience methods
  def reviewer?
    type == 'Reviewer'
  end

  def admin?
    type == 'Admin'
  end
end
