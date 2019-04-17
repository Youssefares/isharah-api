class GestureSerializer
  include FastJsonapi::ObjectSerializer
  attribute :created_at

  attribute :video_url

  has_one :review
  belongs_to :user
  belongs_to :word
end
