class Category < ApplicationRecord
	validates :slug, presence: true, uniqueness: true
	validates :label, presence: true, uniqueness: true
	
end
