require 'spec_helper'

feature "visitor checks course intro" do
  given!(:ruby) { Fabricate(:course, title: "Ruby", published: true) }
  given!(:rails) { Fabricate(:course, title: "Rails", published: true) }
  given!(:tdd) { Fabricate(:course, title: "TDD", published: true) }

  scenario "sees all courses pop in seqence", :js do
    visit root_path
    within(".ta-leaf") do
      expect(page).to have_content "Tealeaf Academy"
      expect(page).to_not have_content "presents"

      expect(page).to have_content "presents", wait: 4

      expect(page).to_not have_content "Ruby"
      expect(page).to_not have_content "Rails"
      expect(page).to_not have_content "TDD"

      expect(page).to have_content "Ruby",  wait: 4
      expect(page).to have_content "Rails", wait: 4
      expect(page).to have_content "TDD",   wait: 4
    end
  end
end
