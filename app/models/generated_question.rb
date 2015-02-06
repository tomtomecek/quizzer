class GeneratedQuestion < ActiveRecord::Base
  belongs_to :question
  belongs_to :exam
  has_many :generated_answers, dependent: :destroy  
end
