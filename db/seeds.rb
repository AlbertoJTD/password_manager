# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

5.times do
  password = Faker::Internet.password
  User.create!(
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.now
  )
end

50.times do
  user = User.all.sample
  user.passwords.create(
    service: Faker::Company.name,
    url: Faker::Internet.url,
    username: Faker::Internet.username,
    password: Faker::Internet.password
  )
end
