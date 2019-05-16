class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name, :uid, :email, :city, :country,
             :type, :date_of_birth, :gender, :bio, :image, :created_at,
             :accepted_contributions_count, :rejected_contributions_count,
             :pending_contributions_count, :reviews_count
end
