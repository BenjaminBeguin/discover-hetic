class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :email, format: { with: /\w*@\w*\.\w*/ }, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_attached_file :avatar,
					 # :storage => :s3,
					 # :bucket => "http://discover-hetic.s3.amazonaws.com",
					  :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
