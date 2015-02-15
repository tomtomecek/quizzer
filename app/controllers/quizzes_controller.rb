class QuizzesController < AdminController
  before_action :find_quiz, only: [:show, :edit, :update]
  rescue_from ActiveRecord::NestedAttributes::TooManyRecords, with: :too_many_records

  def new
    course = Course.find_by(slug: params[:course_id])
    @quiz = course.quizzes.build
  end

  def create
    @course = Course.find_by(slug: params[:course_id])

    @quiz = @course.quizzes.build(quiz_params)

    if @quiz.save
      flash[:success] = "Successfully created new quiz."
      redirect_to admin_course_url(@course)
    else
      flash.now[:danger] = "Quiz creation failed - check errors below:"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @quiz.update(quiz_params)
      flash[:success] = "Quiz was successfully updated."
      redirect_to admin_course_path(@quiz.course)
    else
      flash.now[:danger] = "Quiz creation failed - check errors below:"
      render :edit
    end
  end

private

  def find_quiz
    @quiz = Quiz.find_by(slug: params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(
      :title,
      :description,
      :passing_percentage,
      :published,
      questions_attributes: [
        :id,
        :content,
        :points,
        :_destroy,
        answers_attributes: [
          :id,
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

  def too_many_records(error)
    downsize_params
    flash.now[:info] = "Quiz creation failed - #{error.message}"

    if @quiz.nil?
      @quiz = @course.quizzes.build(quiz_params)
      render :new
    else
      render :edit
    end
  end
end
