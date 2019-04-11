class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name, :uid, :email, :city, :country,
             :date_of_birth, :gender, :bio, :image, :created_at
end
