class EnrollmentsController < ApplicationController
  before_action :require_user

  def new
    course = Course.find(params[:course_id])
    @enrollment = course.enrollments.build
  end

  def create
    course = Course.find(params[:enrollment][:course_id])
    @enrollment = current_user.enrollments.build(enrollment_params)

    if @enrollment.valid?
      if enrollment_paid?
        charge = StripeWrapper::Charge.create(
          amount: 1999,
          card_token: params[:stripeToken]
        )
        if charge.successful?
          @enrollment.save
          EnrollmentMailer.delay.welcome_signature_track(current_user, course)
          Permission.create(student: current_user, enrollment: @enrollment, quiz: course.starting_quiz) if course.published_quizzes.any?
          flash.keep[:success] = "You have now enrolled course #{course.title}"
          render js: "window.location.replace('#{course_url(course)}');"
        else
          @error = charge.error_message
          flash.now[:danger] = @error
          render :new
        end
      elsif enrollment_free?
        @enrollment.save
        Permission.create(student: current_user, enrollment: @enrollment, quiz: course.starting_quiz) if course.published_quizzes.any?
        flash.keep[:success] = "You have now enrolled course #{course.title}"
        render js: "window.location.replace('#{course_url(course)}');"
      else
        @error = "Invalid operation."
        flash.now[:danger] = @error
        render :new
      end
    else
      render :new
    end
  end

private

  def enrollment_paid?
    params[:enrollment][:paid] == "1" && params[:stripeToken].present?
  end

  def enrollment_free?
    params[:enrollment][:paid] == "0"  && params[:stripeToken].nil?
  end

  def enrollment_params
    params.require(:enrollment).permit(:course_id, :paid, :honor_code)
  end
end
