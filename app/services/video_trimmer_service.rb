class VideoTrimmerService
  @timeout = 30
  def initialize(input_path, start, finish)
    tmp_file_name = "#{input_path}_temp"
    @command = [
      'ffmpeg', '-i', input_path.to_s, '-f', 'mp4', '-ss', start.to_s,
      '-t', finish.to_s, '-async', '1', '-f', 'mp4', tmp_file_name.to_s, '-y'
    ]
    @cleanup_command = ['mv', tmp_file_name.to_s, input_path.to_s]
  end

  def trim
    Subprocess.check_call(@command, timeout: @timeout)
    Subprocess.check_call(@cleanup_command, timeout: @timeout)
  rescue Subprocess::NonZeroExit => e
    puts e.message
    puts 'Trimming failed.'
  rescue Subprocess::CommunicateTimeout => e
    puts e.message
    puts 'Trimming failed due to Timeout.'
  end
end
