require "spec_helper"

RSpec.describe "User", :type => :model do

  it "can be saved" do
    user = User.create(first_name: "Jean", last_name: "Villagois", email: "jean@gmail.com", password: "password")
    user.save!

    found = User.last
    expect(found.first_name).to eq("Jean")
    expect(found.last_name).to eq("Villagois")
    expect(found.email).to eq("jean@gmail.com")
  end

  it "requires a first name,lastname, an email and a password" do
    user = User.new
    expect(user.valid?).to eq(false)

    user.first_name = "Clement"
    user.last_name = "Rotule"
    expect(user.valid?).to eq(false)

    user.email = "r@rshow.com"
    expect(user.valid?).to eq(false)

    user.password = "password"
    expect(user.valid?).to eq(true)

  end

  it "requires a somewhat valid email" do
    user = User.new(first_name: "Jean", last_name: "Villagois" , password: "jesuislepassword" )
    expect(user.valid?).to eq(false)

    user.email = "rigby"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rshow"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rssshow.com"

    expect(user.valid?).to eq(true)
  end

  it "requires more than 6 caracteres for password" do
    user = User.new(first_name: "Jean", last_name: "Villagois" , email: "rigby@rssshow.com" )
    expect(user.valid?).to eq(false)

    user.password = "12345"
    expect(user.valid?).to eq(false)

    user.password = "Aze12"
    expect(user.valid?).to eq(false)

    user.password = "Aze124"

    expect(user.valid?).to eq(true)
  end

  it "is impossible to add the same email twice" do
    user = User.create(first_name: "Jean", last_name: "Villagois" , email: "m@rshow.com" , password: "jesuislepassword")
    expect(user.valid?).to eq(true)

    other_user = User.create(first_name: "Jean", last_name: "Villagois" , email: "m@rshow.com" , password: "jesuislepassword")
    expect(other_user.valid?).to eq(false)
  end

  it "password is encoded" do
    user = User.create(first_name: "Jean", last_name: "Villagois" , email: "m@rshow.com" , password: "jesuislepassword")
    expect(user.valid?).to eq(true)


    userFromDB = User.last
    expect(userFromDB.first_name).to eq("Jean")
    expect(userFromDB.last_name).to eq("Villagois")
    expect(userFromDB.email).to eq("m@rshow.com")

    expect(userFromDB.password == user.password).to eq(false)




  end

end
