require 'rails_helper'

describe UsersController do

	it "Can link a post to a user" do
	  user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
	  user.save!
	  post = Post.create(title: "Titre", content: "contenu", category_id: 1 , url: "https://www.google.fr/" , user_id: user.id)
	  post.save!

	  found_user = User.last
	  found_post = Post.last
	  expect(found_user.name).to eq("Jean")
	  expect(found_user.email).to eq("jean@gmail.com")

	  expect(found_post.title).to eq("Titre")
	  expect(found_post.user.name).to eq("Jean")
	  expect(found_post.content).to eq("contenu")
	end

	it "a not login user cant edit a post" do
	  user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
	  user.save!
	  post = Post.create(title: "Titre", content: "contenu", category_id: 1, url: "https://www.google.fr/" , user_id: user.id)
	  post.save!

	  found_user = User.last
	  found_post = Post.last
	  expect(found_user.name).to eq("Jean")
	  expect(found_user.email).to eq("jean@gmail.com")

	  expect(found_post.title).to eq("Titre")
	  expect(found_post.user.name).to eq("Jean")
	  expect(found_post.content).to eq("contenu")

	  get :edit_user_post , { id: post.id}
	  expect(response).to_not have_http_status(:success)
	  
	
	end

	login_user

	it "a login user can edit him post" do
		post = Post.create(title: "Titre", content: "contenu", category_id: 1,url: "https://www.google.fr/" , user_id: subject.current_user.id)
		post.save!

		found_post = Post.last


		expect(found_post.title).to eq("Titre")
		expect(found_post.content).to eq("contenu")

		expect(subject.current_user).to_not eq(nil)

		get :edit_user_post , params: { id: post.id }

		expect(response).to have_http_status(:success)
	end

	it "a login user can not edit not him post" do
		post = Post.create(title: "Titre", content: "contenu", category_id: 1, url: "https://www.google.fr/" , user_id: subject.current_user.id + 1)
		post.save!

		found_post = Post.last


		expect(found_post.title).to eq("Titre")
		expect(found_post.content).to eq("contenu")

		expect(subject.current_user).to_not eq(nil)
		get :edit_user_post , { id: post.id }

		expect(response).to_not have_http_status(:success)
	end


  	

	it "should have a current_user" do
		# note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
		expect(subject.current_user).to_not eq(nil)
	end

	it "should get index" do
		# Note, rails 3.x scaffolding may add lines like get :index, {}, valid_session
		# the valid_session overrides the devise login. Remove the valid_session from your specs
		get 'index'

		expect(response).to be_success
		expect(response).to have_http_status(200)
	end
end

