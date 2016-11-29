class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	validates :name, presence: true, uniqueness: true
	validates :email, presence: true, format: { with: /\w*@\w*\.\w*/ }, uniqueness: true


  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_attached_file :avatar,
					 # :storage => :s3,
					 # :bucket => "http://discover-hetic.s3.amazonaws.com",
					  :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

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


end
