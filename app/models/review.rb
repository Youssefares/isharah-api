class Review < ApplicationRecord
  belongs_to :gesture
  belongs_to :reviewer, class_name: 'User'

  validates :accepted, inclusion: { in: [true, false] }
  validate :reviewer_has_reviewer_priveleges

  def reviewer_has_reviewer_priveleges
    return if reviewer.reviewer? || reviewer.admin?

    errors.add(:user_id, 'should have reviewing priveleges')
  end
end
