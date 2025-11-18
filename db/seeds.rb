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
puts "Created #{Story.count} stories"
