require 'spec_helper'

feature 'object management during quiz creation', js: true do
  given!(:ruby) { Fabricate(:course, title: 'Ruby course') }
  background do
    sign_in_admin    
    visit new_quiz_path(course_id: ruby.slug)
  end

  scenario 'admin removes question' do
    skip
    within(:css, '.question') do
      find(:css, '.fa-trash').click
    end
    expect(page).to have_no_css('.question')
  end

  scenario 'admin removes answer'
  scenario 'admin adds question'
  scenario 'admin adds answer'
end
