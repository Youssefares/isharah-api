# User model class
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :first_name, :last_name, :gender,
            :city, :country, :date_of_birth, presence: true
  validates :email, presence: true, uniqueness: true
end
