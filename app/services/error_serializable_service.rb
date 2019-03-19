class ErrorSerializableService
  def initialize(input_name:, error_string:)
    @input_name = input_name
    @error_string = error_string
  end

  def build_hash
    {
      errors: {
        @input_name => [
          @error_string
        ]
      }
    }
  end
end
