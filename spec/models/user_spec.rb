require "spec_helper"

RSpec.describe "User", :type => :model do

  it "can be saved" do
    user = User.create(name: "Mordecai", email: "m@rshow.com")
    user.save!

    found = User.last
    expect(found.name).to eq("Mordecai")
    expect(found.email).to eq("m@rshow.com")
  end

  it "requires a name and an email" do
    user = User.new
    expect(user.valid?).to eq(false)

    user.name = "Rigby"
    expect(user.valid?).to eq(false)

    user.email = "r@rshow.com"
    expect(user.valid?).to eq(true)
  end

  it "requires a somewhat valid email" do
    user = User.new(name: "Rigby")
    expect(user.valid?).to eq(false)

    user.email = "rigby"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rshow"
    expect(user.valid?).to eq(false)

    user.email = "rigby@rshow.com"
    expect(user.valid?).to eq(true)
  end

  it "is impossible to add the same email twice" do
    user = User.create(name: "Mordecai", email: "m@rshow.com")
    expect(user.valid?).to eq(true)

    other_user = User.create(name: "Mordecai", email: "m@rshow.com")
    expect(other_user.valid?).to eq(false)
  end

  it "exists a method to export all data to json" do
    user = User.create(name: "Mordecai", email: "m@rshow.com")
    other_user = User.create(name: "Javier", email: "jav@ier.com")
    res = User.export(format: :json)
    expect(res).to eq('[{"id":'+user.id.to_s+',"name":"Mordecai","email":"m@rshow.com"},{"id":'+other_user.id.to_s+',"name":"Javier","email":"jav@ier.com"}]')

    expect{User.export(format: :xml)}.to raise_error(ArgumentError)

    # For more info about errors and exceptions in Ruby
    # http://rubylearning.com/satishtalim/ruby_exceptions.html
  end
end
