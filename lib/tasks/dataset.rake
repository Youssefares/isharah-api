require 'zip'

namespace :dataset do
  desc 'generates .zip file for dataset'

  task generate: :environment do
    zipfile_name = 'dataset.zip'
    File.delete(zipfile_name) if File.exist?(zipfile_name)

    create_zip_file(zipfile_name)

    blob = ActiveStorage::Blob.create_after_upload!(
      io: File.open(zipfile_name),
      filename: zipfile_name
    )
    File.delete(zipfile_name)
    puts Rails.application.routes.url_helpers.rails_blob_url(blob)
  end

  def create_zip_file(zipfile_name)
    # Create zip file with accepted gesture videos organised in word folders
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      Word.eager_load(:gestures).each do |word|
        word.gestures.accepted(true).order(:created_at)
            .each_with_index do |gesture, index|

          # Get file extension for convenience
          gesture_filename = gesture.video.blob.filename
          ext = gesture_filename.extension_with_delimiter

          # Construct filename from user id and gesture index for this word
          filename = "#{word.name}/#{index}_user_#{gesture.user.id}#{ext}"

          # Add file (and create directory if necessary)
          zipfile.add(filename, gesture.video_path)
        end
      end
    end
  end
end
