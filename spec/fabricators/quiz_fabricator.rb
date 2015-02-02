Fabricator(:quiz) do
  title { Faker::Lorem.words(3).join(' ') }
  description { Faker::Lorem.paragraph }
  course
  questions(count: 1)
end