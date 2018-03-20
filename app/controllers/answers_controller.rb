class AnswersController < AdminController
  include AnswerExceptions

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    ActiveRecord::Base.transaction do
      @answer.update(answer_params)
      if @answer.valid?
        flash.now[:success] = "Successfully updated answer."
      else
        raise ActiveRecord::RecordInvalid.new(@answer)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:danger] = e.message
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
    @answer.destroy
    @destroyed = true
  end
end
