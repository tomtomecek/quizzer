class QuizzesController < AdminController
  def new
    course = Course.find_by(slug: params[:course_id])
    @quiz = course.quizzes.build
  end

  def create
    course = Course.find_by(slug: params[:course_id])
    @quiz = course.quizzes.build(quiz_params)

    if @quiz.save
      flash[:success] = "Successfully created new quiz."
      redirect_to admin_course_url(course)
    else
      flash.now[:danger] = "Quiz creation failed - check errors below:"
      render :new
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      :title,
      :description,
      :published,
      questions_attributes: [
        :content,
        :points,
        answers_attributes: [
          :content,
          :correct
        ]
      ]
    )
  end
end
