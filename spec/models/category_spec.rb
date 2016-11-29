require 'rails_helper'

RSpec.describe Category, type: :model do


    it "need a label and slug" do
      my_category = Category.create(label: "My Categorie")

      my_last_category = Category.last
      expect(my_last_category.label).to eq("My Categorie")
      expect(my_last_category.slug).to eq("my_categorie")


      my_category = Category.create(label: "slauté @ oué cc'est la vie")
      my_last_category = Category.last
      expect(my_last_category.label).to eq("slauté @ oué cc'est la vie")
      expect(my_last_category.slug).to eq("slaut_at_ou_ccest_la_vie")
    end


end
