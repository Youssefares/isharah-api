class VideoPreviewer < ActiveStorage::Previewer
  def self.accept?(_blob)
    # FIXME: this should check blob content type & make sure ffmpeg supports it.
    true
  end

  def preview
    download_blob_to_tempfile do |input|
      draw_relevant_frame_from input do |output|
        yield io: output,
              filename: "#{blob.filename.base}.jpeg",
              content_type: 'image/jpeg'
      end
    end
  end

  private

  def draw_relevant_frame_from(file, &block)
    draw ffmpegthumbnailer_path, '-i', file.path, '-o', '-',
         '-s', '404', '-t', '30', '-c', 'jpeg', '-', &block
  end

  def ffmpegthumbnailer_path
    ActiveStorage.paths[:ffmpeg] || 'ffmpegthumbnailer'
  end
end
