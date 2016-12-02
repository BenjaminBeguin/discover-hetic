class AddVoteTodayForPostDefaultValue < ActiveRecord::Migration[5.0]
  def change
  	change_column :posts, :vote_created , :integer, :default => 0
  end
end
