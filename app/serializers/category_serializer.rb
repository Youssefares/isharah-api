class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attribute :name

  has_one :parent
  has_many :ancestors
  has_many :descendants
  has_many :children
end
