class AddDescForUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :desc, :text
  end
end
