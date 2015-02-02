Fabricator(:answer) do
  content { Faker::Lorem.words(3).join(' ') }
  correct { [true, false].sample }
end

Fabricator(:correct, from: :answer) do
  correct { true }
end

Fabricator(:incorrect, from: :answer) do
  correct { false }
end
