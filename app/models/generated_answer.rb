class GeneratedAnswer < ActiveRecord::Base
  belongs_to :generated_question
  belongs_to :answer
end
