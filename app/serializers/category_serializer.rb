class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attribute :name

  has_one :parent do |category|
  	category.parent
  end
  has_many :ancestors do |category|
  	category.ancestors
  end
  has_many :descendants do |category|
  	category.descendants
  end
  has_many :children do |category|
  	category.children
  end

end
