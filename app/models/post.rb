class Post < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :comments

	validates :url, :format => URI::regexp(%w(http https));


	#default_scope { where(published: true) }

end
