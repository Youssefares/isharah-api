class Gesture < ApplicationRecord
  # Use active storage to attach video to a record
  has_one_attached :video

  belongs_to :word
  belongs_to :user
  has_one :review

  validates :primary_dictionary_gesture, presence: true
end
