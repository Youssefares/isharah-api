class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attribute :name

  has_one :parent, serializer: :category, if: proc { |_, params|
    params && params[:include_relations] == true
  }
  has_many :ancestors, serializer: :category, if: proc { |_, params|
    params && params[:include_relations] == true
  }
  has_many :descendants, serializer: :category, if: proc { |_, params|
    params && params[:include_relations] == true
  }
  has_many :children, serializer: :category, if: proc { |_, params|
    params && params[:include_relations] == true
  }
end
