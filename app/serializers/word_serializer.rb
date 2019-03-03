class WordSerializer < ActiveModel::Serializer
  attributes :id, :name, :categories
  def categories
    object.categories.map do |category|
      { name: category.name }
    end
  end
end
