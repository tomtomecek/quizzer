module ExpectationMacros
  def expect_to_see(text, options = {})
    expect(page).to have_content(text, options)
  end

  def expect_to_not_see(text, options = {})
    sleep 0.1
    expect(page).to have_no_content(text, options)
  end
  alias_method :expect_not_to_see, :expect_to_not_see

  def expect_to_be_in(path)
    expect(current_path).to eq path
  end

  def expect_to_see_no_modal
    expect(page).to have_no_css(".modal")
  end

  def expect_to_see_in_email(text)
    expect(current_email).to have_content text
  end
end
