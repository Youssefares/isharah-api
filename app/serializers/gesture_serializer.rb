class GestureSerializer
  include FastJsonapi::ObjectSerializer
  attributes :word do |gesture|
    gesture.word.name
  end

  belongs_to :user, record_type: :contributor
  # TODO: add video attachment somehow
end
