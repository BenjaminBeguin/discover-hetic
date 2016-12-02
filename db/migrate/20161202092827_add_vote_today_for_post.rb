class AddVoteTodayForPost < ActiveRecord::Migration[5.0]
  def change
  	add_column :posts, :vote_created, :integer
  end
end
