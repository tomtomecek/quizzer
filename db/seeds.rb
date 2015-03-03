chris = Admin.create!(username: "Chris",
                      email: "chris@example.com",
                      password: "123456",
                      role: "Instructor",
                      full_name: "Chris Lee",
                      activated: true)
kevin = Admin.create!(username: "Kevin",
                      email: "kevin@example.com",
                      password: "123456",
                      role: "Instructor",
                      full_name: "Kevin Wang",
                      activated: true)
Admin.create!(username: "teaching assistant",
              email: "ta@example.com",
              password: "123456",
              role: "Teaching assistant",
              full_name: "TA Default",
              activated: true)
Admin.create!(username: "instructor",
              email: "instructor@example.com",
              password: "123456",
              role: "Instructor",
              full_name: "Instructor Default",
              activated: true)
ruby = Course.create!(title: "Introduction to Ruby and Web development",
                  description: Faker::Lorem.paragraph(9),
                  instructor: chris,
                  duration: "4 weeks",
                  min_quiz_count: 4,
                  price_cents: 1999,
                  published: true)
rails = Course.create!(title: "Rapid Prototyping with Ruby on Rails",
                   description: Faker::Lorem.paragraph(9),
                   instructor: chris,
                   duration: "4 weeks",
                   min_quiz_count: 4,
                   price_cents: 1999,
                   published: true)
tdd = Course.create!(title: "Build Robust and Production Quality Applications",
                 description: Faker::Lorem.paragraph(9),
                 instructor: kevin,
                 min_quiz_count: 8,
                 duration: "8 weeks",
                 price_cents: 3999,
                 published: true)

QUIZ_NAMES = [
  "Week 1 - Procedural Programming",
  "Week 2 - Object Oriented Programming",
  "Week 3 - HTTP & Sinatra",
  "Week 4 - Ajax & jQuery"
]
[ruby, rails, tdd].each do |course|
  QUIZ_NAMES.each do |quiz_name|
    q = course.quizzes.build do |quiz|
      quiz.title              = quiz_name
      quiz.description        = Faker::Lorem.paragraph(5)
      quiz.published          = true
      quiz.passing_percentage = 60
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
            answer.correct = false
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
            answer.correct = false
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
            answer.correct = false
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
            answer.correct = false
          end
        end
      end
    end
    q.save
  end
end
