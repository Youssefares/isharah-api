class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attribute :name

  has_one :parent, serializer: :category
  has_many :ancestors, serializer: :category
  has_many :descendants, serializer: :category
  has_many :children, serializer: :category
end
