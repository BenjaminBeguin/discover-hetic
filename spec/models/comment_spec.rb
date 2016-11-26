require 'rails_helper'

RSpec.describe "Comment", type: :model do
  it "is possible to create a comment on a post" do
    my_user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    my_post = Post.new(user: my_user)

    comment = Comment.create(user: my_user, post: my_post, message: "Hello world!")

    expect(comment.message).to eq("Hello world!")
  end

  it "displays a good looking output for comments" do
    my_user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    my_post = Post.new(user: my_user)

    comment = Comment.create(user: my_user, post: my_post, message: "Hello world!")

    expect(comment.formatted_message).to eq(
      "J. G. Quintel said: Hello world!"
    )
  end

  it "allows for advanced customization" do
    my_user = User.create(name: "Rodrigo", email: "quintel@rshow.com")
    my_post = Post.new(user: my_user)

    comment = Comment.create(user: my_user, post: my_post, message: "Impressive!")

    expect(comment.formatted_message(shout: true)).to eq(
      "Rodrigo said: IMPRESSIVE!"
    )
  end

  it "is possible to access a user commented posts" do
    my_user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    some_user = User.create(name: "Zack", email: "z@klein.com")

    my_post = Post.new(user: my_user)
    some_other_post = Post.new(user: some_user)

    Comment.create(user: my_user, post: my_post, message: "Hello world!")
    Comment.create(user: my_user, post: some_other_post, message: "Interesting")

    expect(my_user.commented_posts).to eq([my_post, some_other_post])
  end
end
