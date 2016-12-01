require 'rails_helper'

RSpec.describe Vote, type: :model do



    it "add vote and count plus one for user" do
      	user = User.create(name: "Author", email: "jean@gmail.com", password: "password")
      	user_2 = User.create(name: "Celui qui a voter", email: "qsdsjean@gmail.com", password: "password")

		post = Post.create(
			title: "Titre",
			content: "contenu",
			url: "https://www.google.fr/" ,
			category_id: 1,
			user_id: user.id
			)

		expect(user.vote_count).to eq(0)

		vote = Vote.create(post_id: post.id, user_id: user_2.id)

		user.reload

		expect(user.vote_count).to eq(1)

    end

    it "add vote and count minus one for user" do
      	user = User.create(name: "Author", email: "jean@gmail.com", password: "password")
      	user_2 = User.create(name: "Celui qui a voter", email: "qsdsjean@gmail.com", password: "password")

		my_post = Post.create(
			title: "Titre",
			content: "contenu",
			url: "https://www.google.fr/" ,
			category_id: 1,
			user_id: user.id
			)

		expect(user.vote_count).to eq(0)

		my_vote = Vote.create(post_id: my_post.id, user_id: user_2.id)
		vote1 = Vote.create(post_id: my_post.id, user_id: user.id)

		user.reload

		expect(user.vote_count).to eq(2)


		Vote.destroy(my_vote.id)
		user.reload	

		expect(user.vote_count).to eq(1)


    end
end
