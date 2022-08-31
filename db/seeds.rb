# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Examples:

#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

p "Creating Features"

tags = [
    "All styles",
    "Reggaeton",
    "Pop",
    "Electro",
    "Dance",
    "Old school",
    "Rock",
    "Techno",
    "Grunge",
    "Acid",
    "Funk",
    "Swing",
    "Salsa",
    "French Rap",
    "Drill",
]

tags.each do |tag|
    Tag.create({name: tag})
end

categories = [
    "Night club",
    "Bar",
    "Concert",
]

categories.each do |category|
    Category.create!({name: category})
end

features = tags + categories

N_FEATURES = features.length
N_TAGS = tags.length
N_CATS = categories.length
N_USER_CLUSTERS = 6
N_USER_FEATURES = 9
N_ITEM_CLUSTERS = 4
N_ITEM_TAGS = 6
N_ITEM_CATS = 1


user_clusters = []
N_USER_CLUSTERS.times do
    cluster = {}
    distribution = [1] * N_USER_FEATURES + [0] * (N_FEATURES - N_USER_FEATURES)
    features.each do |feature|
        cluster[feature] = distribution.sample
    end
    user_clusters.append(cluster)
end

item_clusters = []
N_ITEM_CLUSTERS.times do
    cluster = {}
    tag_distribution = [1] * N_ITEM_TAGS + [0] * (N_TAGS - N_ITEM_TAGS)
    tags.each do |tag|
        cluster[tag] = tag_distribution.sample
    end
    cat_distribution = [1] * N_ITEM_CATS + [0] * (N_CATS - N_ITEM_CATS)
    categories.each do |cat|
        cluster[cat] = cat_distribution.sample
    end
    item_clusters.append(cluster)
end

p "Generating Users"

users = []
1000.times do
    index = rand(0...N_USER_CLUSTERS)
    vector = user_clusters[index].clone
    # Assign user to a cluster
    # Add some variation in the intensity of appreciation
    vector.each do |key, value|
        vector[key] = vector[key] == 1 ? rand(0.6..1) : rand(0.0..0.2)
    end
    # Add some "outliers"
    3.times do
        f = features.sample
        vector[f] = vector[f] > 0.5 ? vector[f] - 0.3 : vector[f] + 0.3
    end
    users.append({
        cluster: "u-#{index}",
        name: Faker::Name.first_name,
        birthday: Faker::Date.birthday(min_age: 5, max_age: 100),
        features: vector
    })
end
    
p "Creating Users"

User.create!(users)

p "Generating Items"

items = []
100.times do
    # Assign item to a cluster
    index = rand(0...N_ITEM_CLUSTERS)
    vector = item_clusters[index].clone
    # Add some "outliers"
    2.times do
        t = tags.sample
        vector[t] = vector[t] == 1 ? 0 : 1
    end
    items.append({
        cluster: "i-#{index}",
        name: Faker::App.name,
        age_restriction: [0, 16, 18].sample,
        features: vector
    })
end
    
p "Creating Items"

Item.create!(items)
    
p "Creating ratings"

rater = FeedbackController.new

User.all.each do |user|
    best_cluster = (0...N_ITEM_CLUSTERS).max_by{|id| Node.cosine_similarity(item_clusters[id], user.normalized_vector, features)}
    25.times do
        cluster = ([best_cluster] * 4 + [rand(0...N_ITEM_CLUSTERS)]).sample
        item = Item.where(cluster: "i-#{cluster}").sample
        rater.adjust_preferences({
            user: user,
            item: item,
            rating: ([rand(0..10)] + [nil] * 10).sample,
            is_in_favourites: ([false] * 3 + [true]).sample,
            visits: ([rand(0..12)] + [0] * 5).sample
        })
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


                