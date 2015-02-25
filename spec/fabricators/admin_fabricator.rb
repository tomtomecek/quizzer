Fabricator(:admin) do
  email { Faker::Internet.email }
  password { "password" }
  role { ["Teaching assistant", "Instructor"].sample }
end

Fabricator(:teaching_assistant, from: :admin) do
  role { "Teaching assistant" }
end

Fabricator(:instructor, from: :admin) do
  role { "Instructor" }
end
