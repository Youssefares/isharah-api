class WordSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :part_of_speech
  attribute :categories do |word|
    word.categories.pluck(:name)
  end
end
