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
      within(:css, ".remove_question") do
        find(:css, ".remove_fields").click
      end
    end
  end

  def remove_answer(order, options = {})
    within(:xpath, "//form/fieldset[#{options[:from]}]/fieldset[#{order}]") do
      find(:css, ".remove_fields").click
    end
  end

  def mark_correct
    find(:css, "input[type=checkbox]").set(true)
  end

  def mark_incorrect
    find(:css, "input[type=checkbox]").set(false)
  end

  def create_all_answers_for(question)
    add_answer(1, to: question, with: "answer") { mark_correct }
    add_answer(2, to: question, with: "answer") { mark_incorrect }
    add_answer(3, to: question, with: "answer") { mark_incorrect }
    add_answer(4, to: question, with: "answer") { mark_incorrect }
  end

  def within_question(n)
    within(:xpath, "//form/fieldset[#{n}]") do
      yield n if block_given?
    end
  end

  def within_exam_question(question)
    within(:css, "#question_#{question.id}") do
      yield
    end
  end
end
