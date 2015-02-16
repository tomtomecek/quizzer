Fabricator(:generated_question) do
  content { Faker::Lorem.paragraph }
  points { 10 }
end

Fabricator(:gen_question, from: :generated_question) do
end
