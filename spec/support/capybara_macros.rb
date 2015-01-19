def expect_to_see(text)
  expect(page).to have_content(text)
end