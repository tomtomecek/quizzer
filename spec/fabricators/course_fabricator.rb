Fabricator(:course) do
  title { Faker::Lorem.words(2).join(' ') }
end