Fabricator(:course) do
  title { Faker::Lorem.words(2).join(' ') }
  description { Faker::Lorem.paragraph }
  price_dollars { Faker::Commerce.price.to_s }
  min_quiz_count { (3..10).to_a.sample }
  instructor
end
