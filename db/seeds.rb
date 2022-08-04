# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "Luca")
Item.create(name: "Test Item")
Business.create(name: "Radar")
Event.create(name: "Paleo")
Edge.create!(node_a: User.first, node_b: Business.first)