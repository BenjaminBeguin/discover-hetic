class ChangeDefaultValueForPostVote < ActiveRecord::Migration[5.0]
  def change
		change_column :posts, :vote , :integer, :default => 0
  end
end
