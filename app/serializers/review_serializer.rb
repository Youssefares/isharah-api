class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  attributes :accepted, :comment, :created_at

  belongs_to :reviewer, serializer: :user
  belongs_to :gesture
end
