class CreateGestures < ActiveRecord::Migration[5.2]
  def change
    create_table :gestures do |t|
      t.belongs_to :word, index: true
      t.belongs_to :user_id, index: true
      t.boolean :primary_dictionary_gesture, default: false, null: false

      t.timestamps
    end
  end
end
