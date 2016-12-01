class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	has_many :posts, :dependent => :destroy
	validates :name, presence: true, uniqueness: true
	validates :slug, uniqueness: true
	validates :email, presence: true, format: { with: /\w*@\w*\.\w*/ }, uniqueness: true

  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_attached_file :avatar,
					  :styles => { 
					  	:medium => "300x300>", 
					  	:thumb => "100x100#" 
				  	  },
					  :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	validate  :url, :if => :check_url

	before_create :add_slug_if_not_exist

	def add_slug_if_not_exist
	    self.slug = self.to_slug
	end

	def to_slug
        ret = self.name.strip
        ret.gsub! /['`]/,""
        ret.gsub! /\s*@\s*/, " at "
        ret.gsub! /\s*&\s*/, " and "
        ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  
        ret.gsub! /_+/,"_"
        ret.gsub! /\A[_\.]+|[_\.]+\z/,""
        ret.downcase
    end

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


end
