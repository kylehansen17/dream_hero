# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.first || User.create(email: "testboi@sam.com", password: "123456")
stories = [{
  name: "Little Red Riding Boot",
  age: 5,
  theme: "adventure",
  system_prompt: "system_prompt"
}, {
  name: "Sam in Wonderland",
  age: 7,
  theme: "fantasy",
  system_prompt: "system_prompt"
}, {
  name: "Dino's Day Out",
  age: 3,
  theme: "cute",
  system_prompt: "system_prompt"
}, {
  name: "Shadows of Eldermoor",
  age: 14,
  theme: "dark",
  system_prompt: "system_prompt"
}
]
puts "Cleaning the DB"
stories.each { |s| Story.create!(s.merge(user: user))}
puts "Created #{Story.count} stories"user = User.first || User.create(email: "testboi@sam.com", password: "123456")
