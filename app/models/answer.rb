class Answer < ActiveRecord::Base
  belongs_to :question
  validates_presence_of :content

  def incorrect?
    !self.correct?
  end

end