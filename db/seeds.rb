# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Add approximatly ten questions for every 2-3 weeks of gameplay
Question.create(text: 'Would you like to watch Westworld?')
Question.create(text: 'Would you like to run a 10K?')
Question.create(text: 'Would you like to take a cooking class from a famous chef?')
# . . .

# Add no more than two users
User.create(name: 'Sonny', mobile: '+14155551212')
User.create(name: 'Cher', mobile: '+15105551212')