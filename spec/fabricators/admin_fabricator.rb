Fabricator(:admin) do
  email { Faker::Internet.email }
  password { "password" }
  role { "teaching assistant" }
end

Fabricator(:instructor, from: :admin) do
  role { "instructor" }
end
