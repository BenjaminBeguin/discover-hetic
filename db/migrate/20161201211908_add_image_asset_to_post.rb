class AddImageAssetToPost < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :posts, :asset
  end
end
