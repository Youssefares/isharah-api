class Review < ApplicationRecord
  belongs_to :gesture
  belongs_to :reviewer, class_name: 'User'
end
