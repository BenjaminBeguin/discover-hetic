require 'rails_helper'

RSpec.describe "Post", :type => :model do
  it "needs to be linked to a user" do
    user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    post = Post.new(user: user, title: "Awesome Message")
    expect(post.user).to eq(user)
    expect(post.user_id).to eq(user.id)

    expect(post.valid?).to eq(true)
    post.user = nil
    expect(post.valid?).to eq(false)
  end

  it "can return the number of characters in the message" do
    post = Post.new(message: "Lorem")
    expect(post.length).to eq(5)
    post = Post.new(message: "Ipsum et dolores")
    expect(post.length).to eq(16)
    post = Post.new(message: "")
    expect(post.length).to eq(nil)
  end

  it "is published by default, but it can be changed" do
    user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    post = Post.create(user: user)
    expect(post.published?).to eq(true)

    post.unpublish!
    expect(post.published?).to eq(false)
  end

  it "exists a method to find all published posts" do
    user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    post = Post.create(user: user)
    other_post = Post.create(user: user)
    Post.create(user: user, published: false)
    Post.create(user: user, published: false)
    Post.create(user: user, published: false)
    expect(Post.published).to eq([post, other_post])
  end

  it "sanitizes titles in DB so they always start with an uppercase letter" do
    user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    post = Post.create!(title: "amazing article", user: user)
    expect(post.title).to eq("Amazing article")

    expect(Post.where(title: "Amazing article").count).to eq(1)
  end

  it "has a way to unpublish all posts" do
    user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    post = Post.create(user: user)
    other_post = Post.create(user: user)
    Post.unpublish_all
    post.reload and other_post.reload
    expect(post.published).to eq(false)
    expect(other_post.published).to eq(false)
  end
end
