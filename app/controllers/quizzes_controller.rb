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

  rescue ActiveRecord::NestedAttributes::TooManyRecords => e
    downsize_params
    @quiz = course.quizzes.build(quiz_params)
    flash.now[:info] = "Quiz creation failed - #{e.message}"
    render :new
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
        :_destroy,
        answers_attributes: [
          :content,
          :correct,
          :_destroy
        ]
      ]
    )
  end

  def downsize_params
    params[:quiz][:questions_attributes].each do |q_attrs|
      until q_attrs[1][:answers_attributes].count <= 10
        q_attrs[1][:answers_attributes].shift
      end
    end
  end
end
