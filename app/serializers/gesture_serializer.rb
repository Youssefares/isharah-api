class GestureSerializer
  include FastJsonapi::ObjectSerializer
  attribute :created_at

  attribute :video_url do |gesture|
    Rails.application.routes.url_helpers.rails_blob_url(gesture.video.blob)
  end

  has_one :review
  belongs_to :user
  belongs_to :word
end
