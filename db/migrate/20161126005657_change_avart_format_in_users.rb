class ChangeAvartFormatInUsers < ActiveRecord::Migration[5.0]
  def self.up
  	remove_column :users, :avatar
    change_table :users do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :users, :avatar
  end
end
