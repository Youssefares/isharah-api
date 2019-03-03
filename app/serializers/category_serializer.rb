class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :words
  def words
    object.words.map do |word|
      { name: word.name }
    end
  end
end
