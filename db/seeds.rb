# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.delete_all

Category.create(label: "Lifestyle")
Category.create(label: "Culture")
Category.create(label: "Tech")
Category.create(label: "Art")
Category.create(label: "Nature")
Category.create(label: "Society")

# User.delete_all

# 10.times do
# 	User.create(
# 		name: Faker::Name.name,
# 		email: Faker::Internet.email,
# 		password: 'testpassword',
# 		url: Faker::Internet.url(),
# 		desc: Faker::Lorem.sentence(7, true)
# 	)
# end

Post.delete_all

5.times do
	Post.create(
		created_at: Faker::Date.between(2.days.ago, Date.today).to_date,
		user_id: User.order("RANDOM()").first.id,
		category_id: Category.order("RANDOM()").first.id,
		title: Faker::Lorem.sentence,
		url: Faker::Internet.url('example.com'),
		content: Faker::Lorem.sentence(7, true),
		asset: 'http://lorempixel.com/800/400/',
		vote: rand(1000),
		vote_created: rand(300)
	)
end

5.times do
Post.create(
		created_at: Faker::Date.between(2.days.ago, Date.today).to_date,
		user_id: User.order("RANDOM()").first.id,
		category_id: Category.order("RANDOM()").first.id,
		title: Faker::Lorem.sentence,
		url: Faker::Internet.url('example.com'),
		content: Faker::Lorem.sentence(7, true),
		vote: rand(1000),
		vote_created: rand(300)
	)
end

5.times do
Post.create(
		created_at: Faker::Date.between(2.days.ago, Date.today).to_date,
		user_id: User.order("RANDOM()").first.id,
		category_id: Category.order("RANDOM()").first.id,
		title: Faker::Lorem.sentence,
		url: Faker::Internet.url('example.com'),
		asset: 'http://lorempixel.com/800/400/',
		vote: rand(1000),
		vote_created: rand(300)
	)
end

5.times do
Post.create(
		created_at: Faker::Date.between(2.days.ago, Date.today).to_date,
		user_id: User.order("RANDOM()").first.id,
		category_id: Category.order("RANDOM()").first.id,
		title: Faker::Lorem.sentence,
		content: Faker::Lorem.sentence(7, true),
		vote: rand(1000),
		vote_created: rand(300)
	)
end

Comment.delete_all
20.times do

	Comment.create(
		post_id: Post.order("RANDOM()").first.id,
		user_id: User.order("RANDOM()").first.id,
		message: Faker::Lorem.sentence(7, true)
	)
end


users = User.all
users.each do |user|

	user_post_count = 0

	user_posts = Post.where(user_id: user.id)
	user_posts.each do |post|
		user_post_count += post.vote
	end

	user.update(vote_count: user_post_count)
end



