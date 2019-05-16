# User model class
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  include DeviseTokenAuth::Concerns::User

  has_many :gestures
  has_many :reviews, foreign_key: :reviewer_id

  validates :first_name, :last_name, :type, presence: true
  validates :email, presence: true, uniqueness: true
  validate :type_is_valid_model_name
  validate :password_complexity
  validate :password_doesnt_match_email

  def self.roles
    %w[Admin Reviewer User]
  end

  def accepted_contributions_count
    gestures.accepted(true).count
  end

  def rejected_contributions_count
    gestures.accepted(false).count
  end

  def pending_contributions_count
    gestures.unreviewed.count
  end

  def password_complexity
    return if provider != 'email' ||
              password =~
              /^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9!@#\$%\^&\*\(\)-=_\+.\?]+)$/

    errors.add :password, :too_weak
  end

  def password_doesnt_match_email
    return if password != email

    errors.add :password, :matches_email
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
