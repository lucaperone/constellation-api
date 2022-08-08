# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

p "Creating Features"

Tag.create!([
    {name: "All styles"},
    {name: "Reggaeton"},
    {name: "Pop"},
    {name: "Electro"},
    {name: "Dance"},
    {name: "Old school"},
    {name: "Rock"},
    {name: "Techno"},
    {name: "Grunge"},
    {name: "Acid"},
    {name: "Funk"},
    {name: "Swing"},
    {name: "Salsa"},
    {name: "French Rap"},
    {name: "Drill"},
    {name: "Drill"},
])

Category.create!([
    {name: "Night club"},
    {name: "Bar"},
    {name: "Concert"},
])

user_clusters = [
    {   # Luca
        "Reggaeton"=>0,
        "Pop"=>0,
        "All styles"=>0,
        "Electro"=>1,
        "Dance"=>0,
        "Old school"=>0,
        "Rock"=>0,
        "Techno"=>1,
        "Grunge"=>0,
        "Acid"=>1,
        "Funk"=>0,
        "Swing"=>0,
        "Salsa"=>0,
        "French Rap"=>1,
        "Drill"=>1,
        "Night club"=>1,
        "Bar"=>0,
        "Concert"=>1
    },
    {   # Gaelle
        "Reggaeton"=>1,
        "Pop"=>0,
        "All styles"=>1,
        "Electro"=>0,
        "Dance"=>1,
        "Old school"=>0,
        "Rock"=>0,
        "Techno"=>0,
        "Grunge"=>0,
        "Acid"=>0,
        "Funk"=>1,
        "Swing"=>1,
        "Salsa"=>1,
        "French Rap"=>0,
        "Drill"=>0,
        "Night club"=>1,
        "Bar"=>1,
        "Concert"=>0
    },
    {   # Eleo
        "Reggaeton"=>1,
        "Pop"=>1,
        "All styles"=>1,
        "Electro"=>0,
        "Dance"=>0,
        "Old school"=>1,
        "Rock"=>1,
        "Techno"=>0,
        "Grunge"=>0,
        "Acid"=>0,
        "Funk"=>0,
        "Swing"=>0,
        "Salsa"=>0,
        "French Rap"=>0,
        "Drill"=>0,
        "Night club"=>1,
        "Bar"=>1,
        "Concert"=>1
    },
    {   # Weird
        "Reggaeton"=>0,
        "Pop"=>0,
        "All styles"=>0,
        "Electro"=>1,
        "Dance"=>0,
        "Old school"=>0,
        "Rock"=>1,
        "Techno"=>0,
        "Grunge"=>1,
        "Acid"=>0,
        "Funk"=>1,
        "Swing"=>0,
        "Salsa"=>0,
        "French Rap"=>0,
        "Drill"=>1,
        "Night club"=>0,
        "Bar"=>1,
        "Concert"=>1
    },
]

item_clusters = [
    {   # Audio
        "Reggaeton"=>0,
        "Pop"=>0,
        "All styles"=>0,
        "Electro"=>1,
        "Dance"=>1,
        "Old school"=>0,
        "Rock"=>0,
        "Techno"=>1,
        "Grunge"=>0,
        "Acid"=>1,
        "Funk"=>0,
        "Swing"=>0,
        "Salsa"=>0,
        "French Rap"=>0,
        "Drill"=>0,
        "Night club"=>1,
        "Bar"=>0,
        "Concert"=>0
    },
    {   # Village
        "Reggaeton"=>1,
        "Pop"=>0,
        "All styles"=>1,
        "Electro"=>0,
        "Dance"=>1,
        "Old school"=>0,
        "Rock"=>0,
        "Techno"=>0,
        "Grunge"=>0,
        "Acid"=>0,
        "Funk"=>0,
        "Swing"=>0,
        "Salsa"=>0,
        "French Rap"=>0,
        "Drill"=>0,
        "Night club"=>1,
        "Bar"=>1,
        "Concert"=>0
    },
    {   # Parf
        "Reggaeton"=>0,
        "Pop"=>1,
        "All styles"=>1,
        "Electro"=>0,
        "Dance"=>0,
        "Old school"=>1,
        "Rock"=>0,
        "Techno"=>0,
        "Grunge"=>0,
        "Acid"=>0,
        "Funk"=>0,
        "Swing"=>0,
        "Salsa"=>0,
        "French Rap"=>0,
        "Drill"=>0,
        "Night club"=>1,
        "Bar"=>1,
        "Concert"=>0
    },
    {   # Guitare en scene
        "Reggaeton"=>0,
        "Pop"=>0,
        "All styles"=>0,
        "Electro"=>0,
        "Dance"=>0,
        "Old school"=>0,
        "Rock"=>1,
        "Techno"=>0,
        "Grunge"=>1,
        "Acid"=>0,
        "Funk"=>1,
        "Swing"=>0,
        "Salsa"=>0,
        "French Rap"=>0,
        "Drill"=>0,
        "Night club"=>0,
        "Bar"=>0,
        "Concert"=>1
    },
    {   # Dance bar
        "Reggaeton"=>1,
        "Pop"=>1,
        "All styles"=>0,
        "Electro"=>0,
        "Dance"=>0,
        "Old school"=>0,
        "Rock"=>0,
        "Techno"=>0,
        "Grunge"=>0,
        "Acid"=>0,
        "Funk"=>0,
        "Swing"=>1,
        "Salsa"=>1,
        "French Rap"=>0,
        "Drill"=>0,
        "Night club"=>0,
        "Bar"=>1,
        "Concert"=>0
    },
]

p "Generating Users"

users = []
1000.times do |i|
    v = user_clusters.sample.clone
    v.each do |key, value|
        v[key] = v[key] == 1 ? (v[key] - rand(0.0..0.4)) : (v[key] + rand(0.0..0.2))
    end
    users.append({
        name: Faker::Name.first_name,
        birthday: Faker::Date.birthday(min_age: 5, max_age: 100),
        features: v
    })
end
    
p "Creating Users"

User.create!(users)

p "Generating Items"

items = []
50.times do |i|
    items.append({
        name: Faker::Cannabis.brand,
        age_restriction: [0, 16, 18].sample,
        features: item_clusters.sample.clone
    })
end
    
p "Creating Items"

Item.create!(items)
    
p "Creating ratings"

User.all.each do |user|
    ids = Item.pluck(:id)
    25.times do
        item = Item.find(ids.sample)
        UserItemEdge.create(
            user: user,
            item: item,
            rating: [rand(0..10), nil].sample,
            is_in_favourites: ([false] * 19).append(true).sample,
            visits: [rand(0..12), 0, 0].sample
        )
    end
end

p "Creating friends"

User.all.each do |user|
    ids = User.where.not(id: user.id).pluck(:id)
    20.times do
        id = ids.sample
        if (UsersEdge.where(user_a: user, node_b_id: id).or(UsersEdge.where(node_a_id: id, user_b: user)).empty?)
            friend = User.find(id)
            UsersEdge.create(
                user_a: user,
                user_b: friend,
                are_friends: true
            )
        end
    end
end


                