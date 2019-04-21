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

  validates_strength_of :password, level: :good, with: :first_name

  def self.roles
    %w[Admin Reviewer User]
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
