Fabricator(:quiz) do
  title { Faker::Lorem.words(3).join(' ') }
  description { Faker::Lorem.paragraph }
  passing_percentage { 0.step(100, 5).to_a.sample }
  course
  questions(count: 1)
end