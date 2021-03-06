class ExamsController < ApplicationController
  before_action :require_user
  before_action :find_quiz
  before_action :require_permission

  def new
    @exam = current_user.exams.find_or_create_by(quiz: @quiz) do |exam|
      exam.student = current_user
      exam.quiz = @quiz
      exam.enrollment = current_user.enrollments.find_by(course: @quiz.course)
      exam.build_questions_with_answers!
      exam.save!
    end
  end

  def show
    @exam = current_user.exams.find(params[:id])
  end

  def complete
    @exam = current_user.exams.find(params[:id])
    enrollment = @exam.enrollment
    student_answers = @exam.generated_answers.
                        where(id: params[:student_answer_ids])
    if answers_valid?(student_answers)
      student_answers.each { |a| a.update_column(:student_marked, true) }
      @exam.grade!
      if @exam.passed?
        if enrollment.is_completed?

          enrollment.update_columns(completed: true)
          flash[:info] = "You have successfully completed this course!"
          if enrollment.paid?
            cert = current_user.certificates.create(enrollment: enrollment)
            EnrollmentMailer.delay.announce_certificate(current_user, cert)
            flash[:info] << " We sent you email with instructions about your certification."
          end
        end
        if @quiz.next_published
          Permission.create(
            student: current_user,
            quiz: @quiz.next_published,
            enrollment: enrollment
          )
        end
        flash[:success] = "Congratulations. You have passed the quiz."
      else
        flash[:warning] = "Sorry, you have to re-attempt the quiz."
      end
      redirect_to [@quiz, @exam]
    else
      flash.now[:danger] = "Failed"
      render :new
    end
  end

private

  def answers_valid?(student_answers)
    student_answers.count == params[:student_answer_ids].count
  end

  def require_permission
    unless current_user.has_permission?(@quiz)
      flash[:danger] = "You don't have permission to do that."
      redirect_to @quiz.course
    end
  end

  def find_quiz
    @quiz ||= Quiz.find_by(slug: params[:quiz_id])
  end
end
