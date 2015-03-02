Fabricator(:admin) do
  full_name { [Faker::Name.first_name, Faker::Name.last_name].join(' ') }
  email { sequence(:email) { |i| "admin#{i}@example.com" } }
  password { "password" }
  role { ["Teaching assistant", "Instructor"].sample }
end

Fabricator(:teaching_assistant, from: :admin) do
  role { "Teaching assistant" }
end

Fabricator(:instructor, from: :admin) do
  role { "Instructor" }
end
