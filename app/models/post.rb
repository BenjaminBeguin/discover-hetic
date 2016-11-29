class Post < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :comments
	cattr_accessor :current_user

	validates :user_id, presence: true

	validates :url, :format => URI::regexp(%w(http https));


	def is_my_post?
	    self.user_id == Post.current_user.id
	end

	#default_scope { where(published: true) }

end
