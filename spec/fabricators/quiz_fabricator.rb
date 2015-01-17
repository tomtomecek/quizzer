Fabricator(:quiz) do
  title { Faker::Lorem.words(3).join(' ') }
  course
end