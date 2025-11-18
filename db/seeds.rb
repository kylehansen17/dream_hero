
DEFAULT_TITLE = "untitled"

puts "Cleaning database..."
# Restaurant.destroy_all
StoryCharacter.destroy_all
Character.destroy_all
Story.destroy_all
User.destroy_all

puts "Creating users..."
sam = User.create!(email: "sam@mail.com", password: "123456")
kyle = User.create!(email: "kyle@mail.com", password: "123456")
tyrhen = User.create!(email: "tyrhen@mail.com", password: "123456")
fan = User.create!(email: "fan@mail.com", password: "123456")

# ----------------------------------

hood = Character.create({
  name: "Little Red Riding Hood",
  occupation: "wolf hunter",
  likes: "grandma",
  user: sam
})

hoodstory = Story.create({
  name: "Little Red Riding Boot",
  age: 5,
  theme: "adventure",
  system_prompt: "",
  user: sam
})


StoryCharacter.create({
  story: hoodstory,
  character: hood,
})

Chat.create({
  title: DEFAULT_TITLE,
  story: hoodstory
})

# ----------------------------------


wolf = Character.create({
  name: "Lupus",
  occupation: "Granny Eater",
  likes: "Grannies",
  user:fan
})

wonderland = Story.create({
  name: "Sam in Wonderland",
  age: 7,
  theme: "fantasy",
  system_prompt: "",
  user: fan
})

StoryCharacter.create({
  story: wonderland,
  character: hood,
})

Chat.create({
  title: DEFAULT_TITLE,
  story: wonderland
})

# -------------------

hood = Character.create({
  name: "Little Red Riding Hood",
  occupation: "wolf hunter",
  likes: "grandma",
  user: tyrhen
})

dino = Story.create({
  name: "Dino's Day Out",
  age: 3,
  theme: "cute",
  system_prompt: "",
  user: tyrhen
})

StoryCharacter.create({
  story: dino,
  character: wolf,
})

Chat.create({
  title: DEFAULT_TITLE,
  story: dino
})

# -------------------

wolf = Character.create({
  name: "Lupus",
  occupation: "Granny Eater",
  likes: "Grannies",
  user: kyle
})


eldermoor = Story.create({
  name: "Shadows of Eldermoor",
  age: 14,
  theme: "dark",
  system_prompt: "",
  user: kyle
})


StoryCharacter.create({
  story: eldermoor,
  character: wolf,
})


Chat.create({
  title: DEFAULT_TITLE,
  story: eldermoor
})
