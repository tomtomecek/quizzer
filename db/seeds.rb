ruby = Course.create(
  title: "Introduction to Ruby and Web development",
  description: Faker::Lorem.paragraph(10))
rails = Course.create(
  title: "Rapid Prototyping with Ruby on Rails",
  description: Faker::Lorem.paragraph(10))
tdd = Course.create(
  title: "Build Robust and Production Quality Applications",
  description: Faker::Lorem.paragraph(10))

procedural = Quiz.create(
  title: "Week 1 - Procedural Programming",
  description: Faker::Lorem.paragraph(5),
  course: ruby)
oop = Quiz.create(
  title: "Week 2 - Object Oriented Programming",
  description: Faker::Lorem.paragraph(5),
  course: ruby)
http_sinatra = Quiz.create(
  title: "Week 3 - HTTP & Sinatra",
  description: Faker::Lorem.paragraph(5),
  course: ruby)
ajax_jquery = Quiz.create(
  title: "Week 4 - Ajax & jQuery",
  description: Faker::Lorem.paragraph(5),
  course: ruby)

question1 = Question.create(
  content: "How much is 1 + 1",
  quiz: procedural,
  value: 1)
question2 = Question.create(
  content: "How much is 2 + 2",
  quiz: procedural,
  value: 1)
question3 = Question.create(
  content: "How much is 3 + 3",
  quiz: procedural,
  value: 1)
question4 = Question.create(
  content: "How much is 4 + 4",
  quiz: procedural,
  value: 2)

4.times do 
  Answer.create(
  question: question1,
  content: "correct answer 2",
  correct: true)
end
6.times do
  Answer.create(
  question: question1,
  content: "incorrect answer - whatever",
  correct: false)
end
