module QuizManagementMacros
  def add_answer(order, options = {})
    click_on "Add Answer"
    within(:xpath, "//form/fieldset[#{options[:to]}]/fieldset[#{order}]") do
      fill_in "Answer", with: options[:with]
      yield if block_given?
    end
  end

  def add_question(order, options = {})
    click_on "Add Question"
    within(:xpath, "//form/fieldset[#{order}]") do
      fill_in "Question", with: options[:with]
      select options[:points]
      yield order if block_given?
    end
  end

  def remove_question(order)
    within(:xpath, "//form/fieldset[#{order}]") do
      find(:css, ".remove_fields").click
    end
  end

  def remove_answer(order, options = {})
    within(:xpath, "//form/fieldset[#{options[:from]}]/fieldset[#{order}]") do
      find(:css, ".remove_fields").click
    end
  end
end
