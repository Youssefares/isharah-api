class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  attributes :accepted, :comment

  belongs_to :reviewer, serializer: :user
  belongs_to :gesture
end
