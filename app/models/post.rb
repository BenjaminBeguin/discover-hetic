class Post < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :comments
	cattr_accessor :current_user

	validates :user_id, presence: true

	#default_scope { where(published: true) }
	#validates :url, :format => URI::regexp(%w(http https));

	before_save :capitalize_title
	
	def show
		@comments = Comment.where(post_id: @post).order('created_at DESC')
	end

	def capitalize_title
		if self.title
	  		self.title = self.title.capitalize
		end
	end

	def is_my_post?
		if Post.current_user
	    	self.user_id == Post.current_user.id
		end
	end

	def published?
		return self.published
	end
end
