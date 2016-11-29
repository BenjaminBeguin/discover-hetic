require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end


  login_user

	    it "is possible to edit a post" do
			post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , user_id: subject.current_user.id)
			post.save!

			patch :update, params: { post: { title: "New titre", content: "new contenu" , id: post.id }
			}
			post.save!

			my_last_post = Post.last

			post.reload
			expect(my_last_post.title).to eq("New titre")
			expect(my_last_post.content).to eq("new contenu")
	    end

	    it "is possible to edit a post" do
			post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , user_id: subject.current_user.id)
			post.save!

			patch :update, params: { post: { title: "New titre", content: "new contenu" , id: post.id }
			}
			post.save!

			my_last_post = Post.last

			post.reload
			expect(my_last_post.title).to eq("New titre")
			expect(my_last_post.content).to eq("new contenu")
	    end

	    it "Post are published by default" do
			post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , user_id: subject.current_user.id)
			post.save!

			expect(post.published).to eq(true)
			
	    end

	    it "Post can be unpublish" do
			my_post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , user_id: subject.current_user.id)
			my_post.save!

			expect(my_post.published).to eq(true)

			post :unpublish!, params: { id: my_post.id }

			post_update = Post.find_by_id(my_post.id)

			expect(post_update.published).to eq(false)

		
	    end

	    it "Post can be unpublish and published again" do
			my_post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , user_id: subject.current_user.id)
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
			my_post = Post.create(title: "Titre", content: "contenu", url: "https://www.google.fr/" , user_id: subject.current_user.id)
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
  	end

end
