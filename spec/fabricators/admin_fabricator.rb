Fabricator(:admin) do
  email { Faker::Internet.email }
  password { "password" }
end

Fabricator(:teaching_assistant, from: :admin) do
  role { "teaching assistant" }
end

Fabricator(:instructor, from: :admin) do
  role { "instructor" }
end
