class Answer < ActiveRecord::Base
  belongs_to :question

  def incorrect?
    !self.correct?
  end

end