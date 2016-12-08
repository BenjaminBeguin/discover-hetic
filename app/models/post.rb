class Post < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :comments 
	has_many :votes 
	cattr_accessor :current_user, :already_voted
	scope :published, -> { where(published: true) }

	validates :user_id, presence: true
	validates :category_id, presence: true
	validates :title, presence: true

	#default_scope { where(published: true) }
	#validates :url, :format => URI::regexp(%w(http https));

	has_attached_file :asset,
					  :styles => { 
					  	:medium => "300x300>", 
					  	:thumb => "100x100#" 
				  	  },
					  :default_url => ""
  	validates_attachment :asset,
  		content_type: { content_type: ["image/jpg", "image/jpeg", "image/gif", "image/png"] }
	validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/
	validates_with AttachmentSizeValidator, attributes: :asset, less_than: 2.megabytes

	before_post_process :check_file_size
	def check_file_size
	  valid?
	  errors[:image_file_size].blank?
	end

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

	def increment
		update(vote: vote + 1)

	end


	def decrement
		update(vote: vote - 1)

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

	def created_today?
		created_at.to_date ==  Date.current
	end

	def self.search(search)
		where("title ILIKE ? OR content ILIKE ?", "%#{search}%", "%#{search}%") 
	end
end
