class ChangeLabelFormatInCategories < ActiveRecord::Migration[5.0]
  def change
  	change_column :categories, :label, :text
  end
end
