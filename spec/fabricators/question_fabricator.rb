Fabricator(:question) do
  content { Faker::Lorem.words(2).join(' ') }
  points { (1..5).to_a.sample }
  answers do
    Fabricate.times(3, :incorrect) << Fabricate(:correct)
  end
end
