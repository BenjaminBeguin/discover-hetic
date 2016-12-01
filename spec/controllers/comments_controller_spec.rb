require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "Commentaires" do
    login_user

    it "user can't post if not logged in" do
      user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
      user.save!

      post = Post.create(title: "Titre", content: "contenu", category_id: 1, url: "https://www.google.fr/" , user_id: user.id)
      post.save!

      comment = Comment.create(message: "Hello premier com", post_id: post.id)
      expect(Comment.last.message).to eq("Hello premier com")

      session.delete(subject.current_user.id)

      comment_after_logout = Comment.create(message: "Hello mon 2éme commentaire", post_id: post.id)
      expect(Comment.last.message).to eq("Hello mon 2éme commentaire")
    end

    it "user can only edit their own comments" do
      user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
      user.save!

      post = Post.create(title: "Titre", content: "contenu", category_id: 1, url: "https://www.google.fr/" , user_id: user.id)
      post.save!

      comment = Comment.create(message: "Hello premier com", post_id: post.id)
      comment.save!
      expect(comment.message).to eq("Hello premier com")

      patch :update, { params: { id: comment.id, post_id: post.id, comment: {message: "Ceci est mon commentaire modifié" } } }
      comment_updated = Comment.last
      comment.reload
      expect(comment_updated.message).to eq("Ceci est mon commentaire modifié")
    end

    it "comments can be deleted" do
      user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
      user.save!

      post = Post.create(title: "Titre", content: "contenu", category_id: 1, url: "https://www.google.fr/" , user_id: subject.current_user.id)
      post.save!

      comment = Comment.create(message: "Hello premier com", post_id: post.id, user_id: subject.current_user.id)
      comment.save!

      expect(Comment.last.message).to eq("Hello premier com")

      delete :destroy, { params: { id: comment.id, post_id: post.id, user_id: subject.current_user.id } }
      expect(Comment.find_by_id(comment.id)).to eq(nil)

      other_comment = Comment.create(message: "Hello premier com", post_id: post.id, user_id: 12)
      other_comment.save!
      delete :destroy, { params: { id: other_comment.id, post_id: post.id, comment: {user_id: subject.current_user.id} } }

      Comment.last.destroy
      expect(Comment.find_by_id(other_comment.id).message).to eq("Hello premier com")
    end
  end

end
