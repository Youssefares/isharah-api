class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end

    create_table :categories_words, id: false do |t|
    	t.belongs_to :word, index: true
    	t.belongs_to :category, index: true
    end
  end
end
