class Answer < ActiveRecord::Base
  belongs_to :question
  # has_many :student_answers
end