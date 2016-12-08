require 'rails_helper'

RSpec.describe "Comment", type: :model do
  it "is linked to a post" do
    user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
    user.save!

    post = Post.create(title: "Titre", content: "contenu", category_id: 1, url: "https://www.google.fr/" , user_id: user.id)
    post.save!

    comment = Comment.create(message: "Hello premier com", post_id: post.id)
    expect(Comment.last.post_id).to eq(post.id)
  end

end