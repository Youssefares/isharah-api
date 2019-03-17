class Gesture < ApplicationRecord
  # Use active storage to attach video to a record
  has_one_attached :video

  belongs_to :word
  belongs_to :user
  has_one :review

  scope :unreviewed, lambda {
    left_outer_joins(:review).where(reviews: { id: nil })
  }
  scope :accepted, lambda { |accepted|
    left_outer_joins(:review).where(reviews: { accepted: accepted })
  }
  scope :dictionary, lambda {
    where(primary_dictionary_gesture: true)
  }
end
