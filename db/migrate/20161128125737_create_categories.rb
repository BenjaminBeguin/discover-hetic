class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.text :slug
      t.integer :label

      t.timestamps
    end
  end
end
