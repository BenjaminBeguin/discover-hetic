require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end


  login_user


	    it "is possible to edit a post" do
			post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" ,category_id: 1, user_id: subject.current_user.id)
			post.save!

			patch :update, { params: { id: post.id, post: { title: "New titre", content: "new contenu",  url: "", category_id: 1 ,id: post.id }}
			}
			post.save!

			my_last_post = Post.last

			post.reload
			expect(my_last_post.title).to eq("New titre")
			expect(my_last_post.content).to eq("new contenu")

	    end

	    it "Post are published by default" do
			post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" ,category_id: 1 , user_id: subject.current_user.id)
			post.save!

			expect(post.published).to eq(true)
			
	    end

	    it "Post can be unpublish" do
			my_post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , category_id: 1, user_id: subject.current_user.id)
			my_post.save!

			expect(my_post.published).to eq(true)

			post :unpublish!, params: { id: my_post.id }

			post_update = Post.find_by_id(my_post.id)

			expect(post_update.published).to eq(false)

		
	    end

	    it "Post can be unpublish and published again" do
			my_post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" ,category_id: 1 , user_id: subject.current_user.id)
			my_post.save!

			expect(my_post.published).to eq(true)

			post :unpublish!, params: { id: my_post.id }

			post_update = Post.find_by_id(my_post.id)

			expect(post_update.published).to eq(false)

			post :publish!, params: { id: my_post.id }

			post_update_twice = Post.find_by_id(my_post.id)

			expect(post_update_twice.published).to eq(true)

	
	    end

	    it "Post can be unpublish and published again if user connected and only his post" do
			my_post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , category_id: 1, user_id: subject.current_user.id)
			my_post.save!

			expect(my_post.published).to eq(true)

			post :unpublish!, params: { id: my_post.id }

			post_update = Post.find_by_id(my_post.id)

			expect(post_update.published).to eq(false)

			Post.current_user.id = nil

			post :publish!, params: { id: my_post.id }

			#delete :destroy, controller: 'users' 

			post_update_twice = Post.find_by_id(my_post.id)

			expect(post_update_twice.published).to eq(false)

	    end

	     it "Can show all post for one user" do
			user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
		  	user.save!
		  	post = Post.create(title: "Titre", content: "contenu", category_id: 1 , url: "https://www.google.fr/" , user_id: user.id)
		  	post.save!

		  	post2 = Post.create(title: "Titre2", content: "contenu2", category_id: 1 , url: "https://www.google.fr/" , user_id: user.id)
		  	post2.save!

		  	from_db_post1 = Post.find_by_id(post.id)
			expect(from_db_post1.published).to eq(true)
			expect(from_db_post1.user.id).to eq(user.id)
			expect(from_db_post1.user.slug).to eq(user.slug)

			get :by_user, params: { slug: user.slug }
			expect(response.body).to include("contenu2")

	    end
	end

	describe "VOTE" do

		login_user

	    it "test multiple vote on post" do
			post1 = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" ,category_id: 1 , user_id: subject.current_user.id)
			post2 = Post.create(title: "Titre2", content: "contenu", url: "https://www.google.fr/" ,category_id: 1 , user_id: subject.current_user.id)
			post3 = Post.create(title: "Titre3", content: "contenu", url: "https://www.google.fr/" ,category_id: 1 , user_id: subject.current_user.id)
			post4 = Post.create(title: "Titre4", content: "contenu", url: "https://www.google.fr/" ,category_id: 1 , user_id: subject.current_user.id)
			post5 = Post.create(title: "Titre5", content: "contenu", url: "https://www.google.fr/" ,category_id: 1 , user_id: subject.current_user.id)
			post1.save!
			post2.save!
			post3.save!
			post4.save!
			post5.save!


			expect(post1.published).to eq(true)
			expect(post2.published).to eq(true)
			expect(post3.published).to eq(true)
			expect(post4.published).to eq(true)
			expect(post5.published).to eq(true)
			
			post :vote, params: { id: post1.id }
			post :vote, params: { id: post2.id }
			post :vote, params: { id: post3.id }

			from_db_post1 = Post.find_by_id(post1.id)
			expect(from_db_post1.published).to eq(true)
			expect(from_db_post1.vote).to eq(1)

			post :vote, params: { id: post1.id }
			post :vote, params: { id: post3.id }

			from_db_post1 = Post.find_by_id(post1.id)
			expect(from_db_post1.published).to eq(true)
			expect(from_db_post1.vote).to eq(0)

			from_db_post2 = Post.find_by_id(post2.id)
			expect(from_db_post2.vote).to eq(1)

			from_db_post3 = Post.find_by_id(post3.id)
			expect(from_db_post3.vote).to eq(0)

			post :vote, params: { id: post5.id }
			post :vote, params: { id: post5.id }
			post :vote, params: { id: post5.id }
			post :vote, params: { id: post5.id }
			post :vote, params: { id: post5.id }
			post :vote, params: { id: post5.id }
			post :vote, params: { id: post5.id }

			from_db_post5 = Post.find_by_id(post5.id)
			expect(from_db_post5.vote).to eq(1)

			post :vote, params: { id: post5.id }

			from_db_post5 = Post.find_by_id(post5.id)
			expect(from_db_post5.vote).to eq(0)

	    end
  	end

end
