class Category < ApplicationRecord
	validates :slug,  uniqueness: true
	validates :label, presence: true, uniqueness: true

	before_create :add_slug_if_not_exist

	def add_slug_if_not_exist
	    self.slug = self.to_slug
	end

	def to_slug
        ret = self.label.strip
        ret.gsub! /['`]/,""
        ret.gsub! /\s*@\s*/, " at "
        ret.gsub! /\s*&\s*/, " and "
        ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  
        ret.gsub! /_+/,"_"
        ret.gsub! /\A[_\.]+|[_\.]+\z/,""
        ret.downcase
    end
end
