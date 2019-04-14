class WordSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :part_of_speech

  has_one :primary_dictionary_gesture,
          record_type: :gesture,
          serializer: GestureSerializer,
          if: proc { |_, params| params && params[:include_gesture] == true }
  has_many :categories
end
