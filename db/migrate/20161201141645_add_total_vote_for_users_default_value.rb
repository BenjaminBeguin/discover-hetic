class AddTotalVoteForUsersDefaultValue < ActiveRecord::Migration[5.0]
  def change
		change_column :users, :vote_count , :integer, :default => 0
  end
end
