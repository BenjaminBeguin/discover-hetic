class Post < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :comments

	cattr_accessor :current_user

	validates :user_id, presence: true
	validates :category_id, presence: true
	validates :title, presence: true

	#default_scope { where(published: true) }
	#validates :url, :format => URI::regexp(%w(http https));

	validate  :check_field
	validate  :url, :if => :check_url

	def check_url
		if (self.url)	
			if !self.url.strip.empty?
				uri = URI.parse(self.url)
				if !%w( http https ).include?(uri.scheme)
					errors.add(:url, "not valid  url")
				end				
			end	
		end
	end

	before_save :capitalize_title

	def check_field
		if (!self.content || self.content == "") && (!self.url || self.url == "")
			errors.add(:content, "Need to choose one more field")
		end
	end
	
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
