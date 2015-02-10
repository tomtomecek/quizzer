class GeneratedAnswer < ActiveRecord::Base
  belongs_to :generated_question
  belongs_to :answer

  def correctly_answered?
    correct? == student_marked?
  end
end
