class WordSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :part_of_speech

  has_one :gesture do |word|
    word.primary_dictionary_gesture
  end

  has_many :categories
end
