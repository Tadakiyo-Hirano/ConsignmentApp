# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
   email: "sample@email.com",
   password: "password",
   name: '管理アカウント'
)

num = 1
5.times do |n|
  User.create!(
    email: "sample-#{n + 1}@email.com",
    password: "password",
    name: "テスト太郎#{n + 1}",
    code: num += 1
  )
end

puts "Sample user created successfully!"