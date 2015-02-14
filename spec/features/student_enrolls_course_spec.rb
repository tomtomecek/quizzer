require 'spec_helper'

feature "student enrolls course" do
  given(:ruby) { Fabricate(:course, title: "Ruby") }
  background do
    Fabricate.times(3, :quiz, course: ruby)
    sign_in
  end

  context "for free", :slow do
    scenario "student enrolls course for free", :js, driver: :selenium do
      expect_to_see_no_modal
      within(:css, "#course_#{ruby.id}") { click_on "Enroll now" }

      within_modal do
        find(:xpath, "//label[contains(.,'Free')]").click
        expect(page).to have_no_css('fieldset.credit_card')
        expect(page).to have_no_css('input[name=stripeToken]')
        check "I agree"
        click_on "Enroll now!"
      end

      expect_to_see_no_modal
      expect_to_be_in course_path(ruby.slug)
      expect_to_see "You have now enrolled course #{ruby.title}"
      expect_to_see "Enrollment: Free"
      expect_to_see "Quizzes: 0 / 3"
    end

    scenario "student does not agree on honor code", :js do
      within(:css, "#course_#{ruby.id}") { click_on "Enroll now" }

      within_modal do
        uncheck "I agree"
        click_on "Enroll now!"
        expect_to_see "Honor code must be accepted"
      end
    end
  end

  context "signature track", :js, :slow do
    background do
      click_enroll(ruby)
      click_on_signature_track
    end

    context "with valid card", driver: :selenium do
      scenario "sucessfull enroll", :vcr do
        expect(page).to have_no_css("input[type=submit]")
        expect(page).to have_css("button[id=stripeSubmit]")
        expect_to_see "you will receive verified certificate via email"
        fill_in_card_details(card_number: "4242424242424242")
        check "I agree"
        click_button "Enroll now!"

        expect_to_see "You have now enrolled course #{ruby.title}"
        expect_to_see "Enrollment: Signature Track"
      end

      scenario "forget to check I agree box" do
        fill_in_card_details(card_number: "4242424242424242")
        click_button "Enroll now!"
        expect_to_see "Honor code must be accepted"
        expect(page).to have_no_css("input[type=submit]")
      end
    end

    context "with declined card", driver: :selenium  do
      scenario "failed enroll card_declined code", :vcr do
        fill_in_card_details(card_number: "4000000000000002")
        check "I agree"
        click_button "Enroll now!"
        expect_to_see "Your card was declined."
      end

      scenario "failed enroll incorrect_cvc code", :vcr do
        fill_in_card_details(card_number: "4000000000000127")
        check "I agree"
        click_button "Enroll now!"
        expect_to_see "Your card's security code is incorrect."
      end

      scenario "failed enroll expired_card code", :vcr do
        fill_in_card_details(
          card_number: "4000000000000069",
          month: "2 - February",
          year: "2015")
        check "I agree"
        click_button "Enroll now!"
        expect_to_see "Your card has expired."
      end

      scenario "failed enroll processing_error code", :vcr do
        fill_in_card_details(card_number: "4000000000000119")
        check "I agree"
        click_button "Enroll now!"
        expect_to_see "An error occurred while processing your card."
        expect_to_see "Try again in a little bit."
      end
    end

    scenario "invalid card", driver: :selenium do
      fill_in_card_details(card_number: "123")
      click_button "Enroll now!"
      expect_to_see "This card number looks invalid."
    end

    scenario "invalid expiration date", driver: :selenium do
      fill_in_card_details(
        card_number: "4000000000000069",
        month: "1 - January",
        year: "2015")
      click_button "Enroll now!"
      expect_to_see "Your card's expiration month is invalid."
    end
  end

  scenario "modal removed when cancelled", :js, :slow do
    click_enroll(ruby)
    within_modal { click_on "Close" }
    expect_to_see_no_modal

    click_enroll(ruby)
    within_modal { find('.modal-header').find(:css, 'button.close').click }
    expect_to_see_no_modal
  end
end

def click_enroll(course)
  within(:css, "#course_#{course.id}") { click_on "Enroll now" }
end

def click_on_signature_track
  find(:xpath, "//label[contains(.,'Signature Track')]").click
end

def fill_in_card_details(options = {})
  year = options[:year] || Time.now.year + 3
  month = options[:month] || "4 - April"
  fill_in "Credit Card Number", with: options[:card_number]
  fill_in "Security Code",      with: "123"
  select month, from: "date_month"
  select year, from: "date_year"
end
