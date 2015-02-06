class AnswersController < AdminController
  include AnswerExceptions
  
  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update(answer_params)
      flash[:success] = "Successfully updated answer."
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    destroy_answer
    flash.now[:success] = "Successfully deleted the answer."
  rescue AnswerException => e
    flash.now[:danger] = e.message
  end

private

  def answer_params
    params.require(:answer).permit(:content, :correct)
  end

  def destroy_answer
    @id = @answer.id
    arr = []
    arr << @answer.question.answers
    arr.flatten!
    arr.delete(@answer)
    unless arr.map(&:correct?).any?
      message = "At least 1 answer must be correct."
      raise AnswerException.new(message: message)
    end
    unless arr.count >= 4
      message = "Question requires at least 4 answers."
      raise AnswerException.new(message: message)
    end
    @answer.destroy
    @destroyed = true
  end
end
