class Review < ApplicationRecord
  belongs_to :gesture
  belongs_to :reviewer, class_name: 'User'

  validates :accepted, inclusion: { in: [true, false] }
  validate :reviewer_has_reviewer_priveleges
  validate :comment_exists_when_rejected

  def reviewer_has_reviewer_priveleges
    return if reviewer.reviewer? || reviewer.admin?

    errors.add(:user_id, 'should have reviewing priveleges')
  end

  # Review rejections should have reason
  def comment_exists_when_rejected
    return if accepted || comment.present?

    errors.add(:comment, "can't be blank when accepted is false")
  end
end
