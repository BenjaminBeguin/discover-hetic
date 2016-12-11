class Vote < ApplicationRecord
	belongs_to :user
	belongs_to :post

	after_save :add_vote_to_user
	before_destroy :remove_vote_to_user

	def add_vote_to_user
		post.user.vote_count += 1
		post.user.save
	end

	def remove_vote_to_user
		post.user.vote_count -= 1
		post.user.save
	end

end
