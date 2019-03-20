class CategorySerializer
  include FastJsonapi::ObjectSerializer
  attribute :name
  # TODO: add category ancestors and descendents here someway
end
