class Word < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :gestures

  validates :name, presence: true, uniqueness: true
  validates :categories, presence: true
  validates :part_of_speech, presence: true,
                             inclusion: { in: %w[اسم فعل حرف] }

  scope :having_public_gestures, lambda {
    left_outer_joins(:gestures).where(
      gestures: { primary_dictionary_gesture: true }
    )
  }

  def primary_dictionary_gesture
    gestures.dictionary.first
  end
end
