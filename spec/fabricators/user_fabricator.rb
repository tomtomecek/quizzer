Fabricator(:user) do
  username { Faker::Name.name }
  email { |attrs| "#{attrs[:username].parameterize}@example.com" }
end