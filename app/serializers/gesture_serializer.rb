class GestureSerializer
  include FastJsonapi::ObjectSerializer
  attribute :created_at

  attribute :video_url
  attribute :preview_url, if: proc { |_, params|
    params && params[:include_preview] == true
  }
  has_one :review
  belongs_to :user
  belongs_to :word
end
