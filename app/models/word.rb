class Word < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :gestures

  validates :name, presence: true, uniqueness: true
  validates :categories, presence: true
end
