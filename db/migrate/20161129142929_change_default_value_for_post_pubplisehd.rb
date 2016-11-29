class ChangeDefaultValueForPostPubplisehd < ActiveRecord::Migration[5.0]
  def change
	change_column :posts, :published , :boolean, :default => true
  end
end
