RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# RSpec without Rails
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end

FactoryGirl.define do
    factory :user do
    	name "Benjaminqscsd"
        email "aabb@hh.de"
        password "jesuislepasswoes"
        password_confirmation "jesuislepasswoes"
    end
end

FactoryGirl.define do
    factory :admin do
    	name "Benjaminqscsd"
        email "aabb@hh.de"
        password "ruby"
        password_confirmation "ruby"
    end
end


