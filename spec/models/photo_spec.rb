require 'rails_helper'

RSpec.describe "Photo", type: :model do
  it "is linked to a post" do
    user = User.create(name: "J. G. Quintel", email: "quintel@rshow.com")
    post = Post.create(user: user, title: "Awesome Message")
    photo = Photo.create(post: post, url: "http://site.com/photo.jpg")

    expect(photo.post.title).to eq(post.title)
    expect(post.photos.count).to eq(1)
  end

  it "validates very basically the URL format and file format should be an image" do
    photo = Photo.new(url: "abcd")
    expect(photo.valid?).to eq(false)

    photo.url = "http:///hello.com/"
    expect(photo.valid?).to eq(false)

    photo.url = "http://site.com/dossier"
    expect(photo.valid?).to eq(false)

    photo.url = "http://site.com/fichier.jpg"
    expect(photo.valid?).to eq(true)

    photo.url = "http://site.com/fichier.exe"
    expect(photo.valid?).to eq(false)
  end

  it "can return file info based on the url" do
    photo = Photo.new

    photo.url = "http://site.com/fichier.jpg"
    expect(photo.file).to eq("fichier.jpg")

    photo.url = "http://site.com/image.jpg"
    expect(photo.file).to eq("image.jpg")

    expect(photo.file_format).to eq("jpg")

    photo.url = "http://site.com/fichier.gif"
    expect(photo.file_format).to eq("gif")
  end

  it "doesn't fail when trying to get the format of a photo with an invalid URL" do
    photo = Photo.new(url: "http://fail.com")
    expect(photo.file_format).to eq(nil)
    expect(photo.file).to eq(nil)
  end

  it "has a method to return all URLs" do
    Photo.create(url: "http://site.com/photo.jpg")
    Photo.create(url: "http://site.com/super_image.jpg")
    Photo.create(url: "http://internet.com/magnifique_photo.jpg")

    expect(Photo.all_urls).to eq(
      [
        "http://site.com/photo.jpg",
        "http://site.com/super_image.jpg",
        "http://internet.com/magnifique_photo.jpg"
      ]
    )
  end
end
