ruby = Course.create(
  title: "Introduction to Ruby and Web development",
  description: Faker::Lorem.paragraph(10)
)

rails = Course.create(
  title: "Rapid Prototyping with Ruby on Rails",
  description: Faker::Lorem.paragraph(10)
)

tdd = Course.create(
  title: "Build Robust and Production Quality Applications",
  description: Faker::Lorem.paragraph(10)
)

procedural = Quiz.create(
  title: "Week 1 - Procedural Programming",
  description: Faker::Lorem.paragraph(5),
  course: ruby
)

oop = Quiz.create(
  title: "Week 2 - Object Oriented Programming",
  description: Faker::Lorem.paragraph(5),
  course: ruby
)

http_sinatra = Quiz.create(
  title: "Week 3 - HTTP & Sinatra",
  description: Faker::Lorem.paragraph(5),
  course: ruby
)

ajax_jquery = Quiz.create(
  title: "Week 4 - Ajax & jQuery",
  description: Faker::Lorem.paragraph(5),
  course: ruby
)
