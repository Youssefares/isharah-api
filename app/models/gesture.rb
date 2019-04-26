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

  def video_url
    Rails.application.routes.url_helpers.rails_blob_url(video.blob)
  end

  def preview_url
    # Get/Generate preview (gets generated once then stored permanently in DB)
    preview = video.preview({})
    Rails.application.routes.url_helpers.rails_representation_url(preview)
  end

  def video_path
    ActiveStorage::Blob.service.send(:path_for, video.key)
  end
end
