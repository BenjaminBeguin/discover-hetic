require 'rails_helper'

RSpec.describe "A post", :type => :model do
	
	it "- Require a title, a user, a category and one other field(url or image or description)" do
		post = Post.create(title: "Titre")
		expect(post.valid?).to eq(false)

		post = Post.create(title: "Titre" , user_id: 1)
		expect(post.valid?).to eq(false)

		post = Post.create(title: "Titre2" , user_id: 1 , category_id: 1)
		expect(post.valid?).to eq(false)

		post = Post.create(title: "Titre3" , user_id: 1 , category_id: 1 , content: "")
		expect(post.valid?).to eq(false)

		post = Post.create(title: "Titre3" , user_id: 1 , category_id: 1 , content: "oui oui")
		expect(post.valid?).to eq(true)

		post = Post.create(title: "Titre4" , user_id: 1 , category_id: 1 , url: "Salut")
		expect(post.valid?).to eq(false)

		post = Post.create(title: "Titre5" , user_id: 1 , category_id: 1 , url: "http://www.facebook.com")
		expect(post.valid?).to eq(true)

		post = Post.create(title: "Titre5" , user_id: 1 , category_id: 1 , url: "")
		expect(post.valid?).to eq(false)
	end

	it " - The file should be a image format" do
	  post = Post.new(title: "Mon joli post", user_id: 1 , category_id: 1, content: "Un joli message")
	  expect(post.valid?).to eq(true)

	  post.asset = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/1f1e6.svg'), 'image/svg');
	  expect(post.valid?).to eq(false)

	  post.asset = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/games.html'), 'file/html');
	  expect(post.valid?).to eq(false)

	  post.asset = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/potté.jpg'), 'image/jpg');
	  expect(post.valid?).to eq(true)

	  post.asset = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/tyrion.png'), 'image/png');
	  expect(post.valid?).to eq(true)
	end

end
