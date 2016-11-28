class Post < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :comments

	#default_scope { where(published: true) }

end
