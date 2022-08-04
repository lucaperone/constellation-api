# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

Tag.create([
    {name: "Reggaeton"},
    {name: "Pop"},
    {name: "All styles"},
    {name: "Electro"},
    {name: "Dance"},
    {name: "Old school"},
    {name: "Rock"},
    {name: "Techno"},
    {name: "Grunge"},
    {name: "Acid"}
])

Category.create([
    {name: "Night club"},
    {name: "Bar"},
    {name: "Concert"},
    {name: "Comedy Club"},
    {name: "Movie"},
    {name: "Play"}
])

p "Generating Users"

users = []
100.times do |i|
    users.append({
        name: Faker::Name.first_name,
        birthday: Faker::Date.birthday(min_age: 5, max_age: 100),
    })
end
    
p "Creating Users"

User.create(users)

p "Generating Items"

items = []
100.times do |i|
    items.append({
        name: Faker::Cannabis.brand,
        age_restriction: [0, 16, 18].sample,
    })
end
    
p "Creating Items"

Item.create(items)
    
p "Updating UserItemEdges"

User.all.each do |user|
    10.times do
        item = Item.find(Item.pluck(:id).sample)
        UserItemEdge.where(user: user, item: item).first.update(
            rating: [rand(0..10), nil].sample,
            is_in_favourites: ([false] * 19).append(true).sample,
            visits: [rand(0..12), 0, nil].sample
        )
    end
end


                