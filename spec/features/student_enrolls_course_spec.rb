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

  context "signature track", :slow do
    background { click_enroll(ruby) }

    context "with valid card" do
      scenario "sucessfull enroll", :js, driver: :selenium do
        within_modal do
          click_on_signature_track
          expect(page).to have_no_css("input[type=submit]")
          expect(page).to have_css("button[id=stripeSubmit]")
          expect_to_see "you will receive verified certificate via email"
          fill_in_card_details(card_number: "4242424242424242")
          check "I agree"
          click_button "Enroll now!"
        end
        expect_to_see "You have now enrolled course #{ruby.title}"
        expect_to_see "Enrollment: Signature Track"
      end

      scenario "forget to check I agree box", :js, driver: :selenium do
        within_modal do
          click_on_signature_track
          fill_in_card_details(card_number: "4242424242424242")
          click_button "Enroll now!"
          expect_to_see "Honor code must be accepted"
          expect(page).to have_no_css("input[type=submit]")
        end
      end
    end

    context "with invalid card", :slow do
      background { click_enroll(ruby) }
      scenario "throws an error", :js, driver: :selenium do
        within_modal do
          click_on_signature_track
          fill_in_card_details(card_number: "123")
          click_button "Enroll now!"
          expect_to_see "This card number looks invalid."
        end
      end
    end

    scenario "modal removed when cancelled", :js do
      click_enroll(ruby)
      within_modal { click_on "Close" }
      expect_to_see_no_modal

      click_enroll(ruby)
      within_modal { find('.modal-header').find(:css, 'button.close').click }
      expect_to_see_no_modal
    end
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
  security_code = options[:security_code] || "123"
  fill_in "Credit Card Number", with: options[:card_number]
  fill_in "Security Code",      with: security_code
  select month, from: "date_month"
  select year, from: "date_year"
end
