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

num1 = 1
30.times do |n|
  User.create!(
    email: "sample-#{n + 1}@email.com",
    password: "password",
    name: "テスト太郎#{n + 1}",
    code: num1 += 1
  )
end

puts "Sample users created successfully!"

num2 = 710011
21.times do |n|
  Product.create!(
    code: num2 += 1,
    name: "テスト商品A#{n + 1}",
    classification: "本機",
    category: "刈払機"
  )
end

9.times do |n|
  Product.create!(
    code: "H50133445#{n + 1}",
    name: "テスト商品B#{n + 1}",
    classification: "本機",
    category: "チェンソー"
  )
end

puts "Sample products created successfully!"
