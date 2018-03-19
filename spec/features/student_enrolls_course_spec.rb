require 'spec_helper'

feature "student enrolls course" do
  given(:chris) { Fabricate(:instructor, username: "Chris") }
  given(:ruby) do
    Fabricate(:course,
              title: "Ruby",
              instructor: chris,
              price_dollars: "49.99",
              published: true)
  end
  background do
    clear_emails
    Fabricate.times(3, :quiz, course: ruby, published: true)
    sign_in
  end
  after { clear_emails }

  context "for free" do
    scenario "student enrolls course for free", :js, :billy do
      expect_to_see_no_modal
      within("#course_#{ruby.id}") { click_on "Enroll now" }

      within_modal do
        click_on_free
        expect(page).to have_no_css('fieldset.credit_card')
        expect(page).to have_no_css('input[name=stripeToken]')
        agree_on_honor_code
        click_on "Enroll now!"
      end

      expect_to_see_no_modal
      expect_to_be_in course_path(ruby.slug)
      expect_to_see "You have now enrolled course #{ruby.title}"
      expect_to_see "Enrollment: Free"
      expect_to_see "Quizzes: 0 / 3"
    end

    scenario "student does not agree on honor code", :js, :billy do
      within("#course_#{ruby.id}") { click_on "Enroll now" }

      within_modal do
        uncheck "I agree"
        click_on "Enroll now!"
        expect_to_see "Honor code must be accepted"
      end
    end
  end

  context "signature track" do
    background do
      click_enroll(ruby)
      click_on_signature_track
    end

    context "with valid card" do
      scenario "sucessfull enroll", :js, :vcr, :billy do
        expect(page).to have_no_css("input[type=submit]")
        expect(page).to have_css("button[id=stripeSubmit]")
        expect_to_see "will receive Certificate of Accomplishment via email"
        fill_in_card_details(card_number: "4242424242424242")
        agree_on_honor_code
        click_paid_enroll_now

        expect_to_see "You have now enrolled course #{ruby.title}"
        expect_to_see "Enrollment: Signature Track"

        open_email("alice@example.com")
        expect(current_email).to have_content "Thank you for your trust in\
          Tealeaf! We confirm the payment - $49.99 for the signature track\
          for course #{ruby.title}."
      end

      scenario "forget to check I agree box", :js, :vcr, :billy do
        fill_in_card_details(card_number: "4242424242424242")
        click_paid_enroll_now
        expect_to_see "Honor code must be accepted"
        expect(page).to have_no_css("input[type=submit]", visible: true)
      end
    end

    context "with declined card" do
      scenario "failed enroll card_declined code", :js, :vcr, :billy do
        fill_in_card_details(card_number: "4000000000000002")
        agree_on_honor_code
        click_paid_enroll_now
        expect_to_see "Your card was declined."
      end

      scenario "failed enroll incorrect_cvc code", :js, :vcr, :billy do
        fill_in_card_details(card_number: "4000000000000127")
        agree_on_honor_code
        click_paid_enroll_now
        expect_to_see "Your card's security code is incorrect."
      end

      scenario "failed enroll expired_card code", :js, :vcr, :billy do
        fill_in_card_details(
          card_number: "4000000000000069",
          month: "2 - February",
          year: (Time.now.year + 1)
        )
        agree_on_honor_code
        click_paid_enroll_now
        expect_to_see "Your card's expiration month is invalid."
      end

      scenario "failed enroll processing_error code", :js, :vcr, :billy do
        fill_in_card_details(card_number: "4000000000000119")
        agree_on_honor_code
        click_paid_enroll_now
        expect_to_see "An error occurred while processing your card."
        expect_to_see "Try again in a little bit."
      end
    end

    context "with invalid card" do
      scenario "invalid card", :js, :vcr, :billy do
        fill_in_card_details(card_number: "123")
        click_paid_enroll_now
        expect_to_see "This card number looks invalid."
      end

      scenario "invalid expiration date", :js, :vcr, :billy do
        fill_in_card_details(
          card_number: "4000000000000069",
          month: "1 - January",
          year: (Time.now.year + 1)
        )
        click_paid_enroll_now
        expect_to_see "Your card's expiration month is invalid."
      end
    end
  end

  scenario "modal removed when cancelled", :js, :billy do
    click_enroll(ruby)
    within_modal { click_on_close_button }
    expect_to_see_no_modal

    click_enroll(ruby)
    within_modal { click_on_cross_icon }
    expect_to_see_no_modal
  end

  def click_enroll(course)
    within("#course_#{course.id}") do
      find("a", text: 'Enroll now').trigger('click')
    end
  end

  def click_on_free
    find(:xpath, "//label[contains(.,'Free')]").trigger('click')
  end

  def click_on_cross_icon
    find('.modal-header').find('button.close').trigger('click')
  end

  def click_on_close_button
    find(:button, "Close").trigger('click')
  end

  def fill_in_card_details(options = {})
    year = options[:year] || Time.now.year + 3
    month = options[:month] || "4 - April"
    fill_in "Credit Card Number", with: options[:card_number]
    fill_in "Security Code",      with: "123"
    select month, from: "date_month"
    select year, from: "date_year"
  end

  def click_on_signature_track
    find(:xpath, "//label[contains(.,'Signature Track')]").trigger('click')
  end

  def agree_on_honor_code
    find('input[type=checkbox]').trigger('click')
  end

  def click_paid_enroll_now
    find('#stripeSubmit').trigger('click')
  end
end
