Fabricator(:answer) do
  content { Faker::Lorem.words(3).join(' ') }
  correct { [true, false].sample }
end