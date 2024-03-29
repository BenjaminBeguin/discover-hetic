class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.string :url
      t.boolean :published
      t.integer :vote
      t.integer :user_id

      t.timestamps
    end
  end
end
