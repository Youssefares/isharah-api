class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.belongs_to :gesture, index: true
      t.integer :reviewer_id, index: true, foreign_key: true
      t.boolean :accepted, null: false
      t.text :comment

      t.timestamps
    end
  end
end
