Admin.create!(email: "ta@example.com", password: "123456", role: "TA")
Admin.create!(
  email: "instructor@example.com",
  password: "123456",
  role: "instructor"
)

ruby = Course.create!(
  title: "Introduction to Ruby and Web development",
  description: Faker::Lorem.paragraph(10))
Course.create!(
  title: "Rapid Prototyping with Ruby on Rails",
  description: Faker::Lorem.paragraph(10))
Course.create!(
  title: "Build Robust and Production Quality Applications",
  description: Faker::Lorem.paragraph(10))

QUIZ_NAMES = [
  "Week 1 - Procedural Programming",
  "Week 2 - Object Oriented Programming",
  "Week 3 - HTTP & Sinatra",
  "Week 4 - Ajax & jQuery"
]

QUIZ_NAMES.each do |quiz_name|
  q = ruby.quizzes.build do |quiz|
    quiz.title       = quiz_name
    quiz.description = Faker::Lorem.paragraph(5)
    quiz.questions.build do |question|
      question.content = "How much is 1 + 1"
      question.points  = 2
      3.times do
        question.answers.build do |answer|
          answer.content = "correct answer is 2"
          answer.correct = true
        end
        question.answers.build do |answer|
          answer.content = "incorrect answer - whatever"
          answer.content = false
        end
      end
    end

    quiz.questions.build do |question|
      question.content = "How much is 2 + 2"
      question.points  = 4
      3.times do
        question.answers.build do |answer|
          answer.content = "correct answer is 4"
          answer.correct = true
        end
        question.answers.build do |answer|
          answer.content = "incorrect answer - whatever"
          answer.content = false
        end
      end
    end

    quiz.questions.build do |question|
      question.content = "How much is 3 + 3"
      question.points  = 5
      3.times do
        question.answers.build do |answer|
          answer.content = "correct answer is 6"
          answer.correct = true
        end
        question.answers.build do |answer|
          answer.content = "incorrect answer - whatever"
          answer.content = false
        end
      end
    end

    quiz.questions.build do |question|
      question.content = "How much is 4 + 4"
      question.points  = 10
      3.times do
        question.answers.build do |answer|
          answer.content = "correct answer is 8"
          answer.correct = true
        end
        question.answers.build do |answer|
          answer.content = "incorrect answer - whatever"
          answer.content = false
        end
      end
    end
  end
  q.save(validate: false)
end
