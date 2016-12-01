# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 5.times do
# 	Category.create(label: Faker::Team.sport)
# end

# 10.times do
# 	Post.create(
# 		user_id: User.order("RANDOM()").first.id,
# 		category_id: Category.order("RANDOM()").first.id,
# 		title: Faker::Lorem.sentence,
# 		url: Faker::Internet.url('example.com'),
# 		content: Faker::Lorem.sentence(7, true)
# 	)
# end

Comment.delete_all
100.times do

	Comment.create(
		post_id: Post.order("RANDOM()").first.id,
		user_id: User.order("RANDOM()").first.id,
		message: Faker::Lorem.sentence(7, true)
	)
end