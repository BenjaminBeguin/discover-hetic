require 'rails_helper'

RSpec.describe "Post", :type => :model do
	 it "Post need a title, a user, a category and one (url or image or description)" do
			post = Post.create(title: "Titre")
			expect(post.valid?).to eq(false)

			post = Post.create(title: "Titre" , user_id: 1)
			expect(post.valid?).to eq(false)

			post = Post.create(title: "Titre2" , user_id: 1 , category_id: 1)
			expect(post.valid?).to eq(false)

			post = Post.create(title: "Titre3" , user_id: 1 , category_id: 1 , content: "oui oui ")
			expect(post.valid?).to eq(true)

			post = Post.create(title: "Titre4" , user_id: 1 , category_id: 1 , url: "Salut")
			expect(post.valid?).to eq(false)

			post = Post.create(title: "Titre5" , user_id: 1 , category_id: 1 , url: "http://www.facebook.com")
			expect(post.valid?).to eq(true)
	    end

end
