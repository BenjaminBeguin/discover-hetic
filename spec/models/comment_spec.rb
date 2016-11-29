require 'rails_helper'

RSpec.describe "Comment", type: :model do
  it "is possible to create a comment on a post" do
    my_user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    my_post = Post.new(user: my_user)

    comment = Comment.create(user: my_user, post: my_post, message: "Hello world!")

    expect(comment.message).to eq("Hello world!")
  end
end
