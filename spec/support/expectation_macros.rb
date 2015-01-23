module ExpectationMacros
  def expect_to_see(text)
    expect(page).to have_content(text)
  end

  def expect_to_not_see(text)
    expect(page).to have_no_content(text)
  end

  def expect_to_be_in(path)
    expect(current_path).to eq path
  end
end
