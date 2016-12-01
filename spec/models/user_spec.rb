require "spec_helper"

RSpec.describe "User", :type => :model do

  it "can be saved" do
    user = User.create(name: "Jean", email: "jean@gmail.com", password: "password")
    user.save!

    found = User.last
    expect(found.name).to eq("Jean")
    expect(found.email).to eq("jean@gmail.com")
  end

  it "requires a name, an email and a password" do
    user = User.new
    expect(user.valid?).to eq(false)

    user.name = "Clement"
    expect(user.valid?).to eq(false)

    user.email = "r@rshow.com"
    expect(user.valid?).to eq(false)

    user.password = "password"
    expect(user.valid?).to eq(true)

  end

  it "requires a somewhat valid email" do
    user = User.new(name: "Jean" , password: "jesuislepassword" )
    expect(user.valid?).to eq(false)

    user.email = "rigby"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rshow"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rssshow.com"

    expect(user.valid?).to eq(true)
  end

  it "requires more than 6 caracteres for password" do
    user = User.new(name: "Jean", email: "rigby@rssshow.com" )
    expect(user.valid?).to eq(false)

    user.password = "12345"
    expect(user.valid?).to eq(false)

    user.password = "Aze12"
    expect(user.valid?).to eq(false)

    user.password = "Aze124"

    expect(user.valid?).to eq(true)
  end

  it "is impossible to add the same email twice" do
    user = User.create(name: "Jean" , email: "m@rshow.com" , password: "jesuislepassword")
    expect(user.valid?).to eq(true)

    other_user = User.create(name: "Jean", email: "m@rshow.com" , password: "jesuislepassword")
    expect(other_user.valid?).to eq(false)
  end

  it "if url is not blank, have to be a real url" do
    user = User.create(name: "Jeaqcn" , email: "m@rshoqscqscw.com" , password: "jesuislepassword", url: "")
    expect(user.valid?).to eq(true)

    other_user = User.create(name: "zC", email: "m@rshqcsow.com" , password: "jesuislepassword", url: "Salut")
    expect(other_user.valid?).to eq(false)

    otherone_user = User.create(name: "BF", email: "m@rshqscqcow.com" , password: "jesuislepassword", url: "https://www.facebook.com/")
    expect(otherone_user.valid?).to eq(true)

  end

   it "is impossible to add the same pseudo twice" do
    user = User.create(name: "Jean" , email: "m@rshsscsow.com" , password: "jesuislepassword")
    expect(user.valid?).to eq(true)

    other_user = User.create(name: "Jean", email: "mscsc@rshow.com" , password: "jesuislepassword")
    expect(other_user.valid?).to eq(false)
  end

  it "password is encoded" do
    user = User.create(name: "Jean", email: "m@rshow.com" , password: "jesuislepassword")
    expect(user.valid?).to eq(true)


    userFromDB = User.last
    expect(userFromDB.name).to eq("Jean")
    expect(userFromDB.email).to eq("m@rshow.com")

    expect(userFromDB.password == user.password).to eq(false)
  end

  it "verify the file format should be an image" do
    user = User.new(name: "Jean Pierre", email: "m@rshow.com" , password: "jesuislepassword")
    expect(user.valid?).to eq(true)

    user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/1f1e6.svg'), 'image/svg');
    expect(user.valid?).to eq(false)

    user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/games.html'), 'file/html');
    expect(user.valid?).to eq(false)

    user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/potté.jpg'), 'image/jpg');
    expect(user.valid?).to eq(true)

    user.avatar = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/tyrion.png'), 'image/png');
    expect(user.valid?).to eq(true)
  end

  it "requires a name,and a slug" do
    user = User.create(name: "Jean Pierre", email: "m@rshow.com" , password: "jesuislepassword")

    userFromDB = User.last
    expect(userFromDB.name).to eq("Jean Pierre")
    expect(userFromDB.slug).to eq("jean_pierre")
  end

  it "no duplicated slug" do
    user = User.create(name: "Jéan Pierre", email: "m@rshow.com" , password: "jesuislepassword")
    userFromDB = User.last
    expect(userFromDB.name).to eq("Jéan Pierre")
    expect(userFromDB.slug).to eq("j_an_pierre")

    other_user = User.create(name: "Jàan Pierre", email: "qscm@rshow.com" , password: "jesuislepassword")

    expect(other_user.valid?).to eq(false)

  end

end
