require "spec_helper"

describe ExamsController do
  let(:ruby) { Fabricate(:course) }
  let(:quiz) do
    Fabricate(:quiz, published: true, passing_percentage: 10, course: ruby)
  end
  before do
    set_current_user
    set_permission(current_user, quiz)
  end
  after { ActionMailer::Base.deliveries.clear }

  describe "GET new" do
    let(:enrollment) do
      Fabricate(:enrollment, course: ruby, student: current_user)
    end
    it_behaves_like "require sign in" do
      let(:action) { get :new, quiz_id: quiz.slug }
    end

    it_behaves_like "requires permission" do
      let(:action) { get :new, quiz_id: quiz.slug }
      let(:redirection) { quiz.course }
    end

    it "sets the @quiz" do
      get :new, quiz_id: quiz.slug
      expect(assigns(:quiz)).to eq(quiz)
    end

    it "sets the @exam" do
      get :new, quiz_id: quiz.slug
      expect(assigns(:exam)).to eq Exam.first
    end

    context "exam exists" do
      it "does not create another exam" do
        Fabricate(:exam, quiz: quiz, student: current_user)
        expect { get :new, quiz_id: quiz.slug }.to_not change { Exam.count }
      end
    end

    context "exam does not exist" do
      let!(:enrollment) do
        Fabricate(:enrollment, course: ruby, student: current_user)
      end
      it "creates new exam" do
        expect { get :new, quiz_id: quiz.slug }.to change { Exam.count }.by 1
      end

      it "creates the exam under enrollments" do
        get :new, quiz_id: quiz.slug
        expect(enrollment.exams).to include Exam.first
      end

      it "generates questions" do
        get :new, quiz_id: quiz.slug
        expect(assigns(:exam).generated_questions).to_not be_empty
      end

      it "generates answers" do
        get :new, quiz_id: quiz.slug
        expect(assigns(:exam).generated_answers).to_not be_empty
      end
    end
  end

  describe "GET show" do
    let(:exam) { Fabricate(:exam, quiz: quiz, student: current_user) }

    it_behaves_like "require sign in" do
      let(:action) { get :show, quiz_id: quiz.slug, id: exam.id }
    end

    it_behaves_like "requires permission" do
      let(:action) { get :show, quiz_id: quiz.slug, id: exam.id }
      let(:redirection) { quiz.course }
    end

    it "sets the @quiz" do
      get :show, quiz_id: quiz.slug, id: exam.id
      expect(assigns(:quiz)).to eq(quiz)
    end

    it "sets the @exam" do
      get :show, quiz_id: quiz.slug, id: exam.id
      expect(assigns(:exam)).to eq(exam)
    end
  end

  describe "PATCH complete" do
    let(:enrollment) do
      Fabricate(:enrollment, student: current_user, course: ruby)
    end
    let(:exam) do
      Fabricate(:exam,
                quiz: quiz,
                student: current_user,
                enrollment: enrollment)
    end

    let(:gq) { Fabricate(:gen_question, exam: exam, points: 10) }
    let(:ga1) { Fabricate(:gen_correct, generated_question: gq) }
    let(:ga2) { Fabricate(:gen_incorrect, generated_question: gq) }
    let(:ga3) { Fabricate(:gen_incorrect, generated_question: gq) }
    let(:ga4) { Fabricate(:gen_incorrect, generated_question: gq) }

    it_behaves_like "require sign in" do
      let(:action) { patch :complete, id: 1, quiz_id: quiz.slug }
    end

    it_behaves_like "requires permission" do
      let(:action) { patch :complete, quiz_id: quiz.slug, id: exam.id }
      let(:redirection) { quiz.course }
    end

    context "with valid data" do
      context "permissions" do
        it "creates permission to next quiz" do
          Fabricate(:quiz, published: true, course: ruby)
          expect {
            patch :complete,
                  id: exam.id,
                  quiz_id: quiz.slug,
                  student_answer_ids: to_ids(ga1)
          }.to change { Permission.count }
        end

        it "sets flash success" do
          Fabricate(:quiz, published: true, course: ruby)
          patch :complete,
                  id: exam.id,
                  quiz_id: quiz.slug,
                  student_answer_ids: to_ids(ga1)
          expect(flash[:success]).to be_present
        end

        it "sets flash warning" do
          Fabricate(:quiz, published: true, course: ruby)
          patch :complete,
                id: exam.id,
                quiz_id: quiz.slug,
                student_answer_ids: to_ids(ga2)
          expect(flash[:warning]).to be_present
        end

        it "does not create permission" do
          Fabricate(:quiz, published: true, course: ruby)
          expect {
            patch :complete,
                  id: exam.id,
                  quiz_id: quiz.slug,
                  student_answer_ids: to_ids(ga2)
          }.to_not change { Permission.count }
        end
      end

      context "exam passed" do
        before do
          patch :complete,
                id: exam.id,
                quiz_id: quiz.slug,
                student_answer_ids: to_ids(ga1)
        end

        it { is_expected.to redirect_to [quiz, exam] }

        it "updates generated answers with student answers" do
          expect(ga1.reload.student_marked?).to be true
          expect(ga2.student_marked?).to be false
          expect(ga3.student_marked?).to be false
          expect(ga4.student_marked?).to be false
        end

        it "sets status to completed" do
          expect(exam.reload).to be_completed
        end

        it "grades the exam when completed" do
          expect(exam.reload.score).to be_present
        end
      end

      context "enrollment completion" do
        context "successfull" do
          before do
            Fabricate.times(2, :quiz, course: ruby, published: true)
            Fabricate.times(2,
                            :exam,
                            student: current_user,
                            enrollment: enrollment,
                            passed: true)
            patch :complete,
                  id: exam.id,
                  quiz_id: quiz.slug,
                  student_answer_ids: to_ids(ga1)
          end

          it "completes the enrollment" do
            expect(enrollment.reload).to be_completed
          end

          it "sets the flash info" do
            is_expected.to set_the_flash[:info]
          end
        end

        it "does not complete the enrollment" do
          Fabricate.times(3, :quiz, course: ruby, published: true)
          Fabricate.times(2,
                          :exam,
                          student: current_user,
                          enrollment: enrollment,
                          passed: true)
          patch :complete,
                id: exam.id,
                quiz_id: quiz.slug,
                student_answer_ids: to_ids(ga1)
          expect(enrollment.reload).to_not be_completed
        end

        context "paid enrollment" do
          before do
            Fabricate.times(2, :quiz, course: ruby, published: true)
            Fabricate.times(2,
                            :exam,
                            student: current_user,
                            enrollment: enrollment,
                            passed: true)
            enrollment.update_columns(paid: true)
            patch :complete,
                  id: exam.id,
                  quiz_id: quiz.slug,
                  student_answer_ids: to_ids(ga1)
          end

          it "creates certificate" do
            expect(Certificate.count).to eq 1
          end

          it "sends out email" do
            expect(ActionMailer::Base.deliveries).to_not be_empty
          end

          it "sends out email to student" do
            mail = ActionMailer::Base.deliveries.last
            expect(mail.to).to eq [current_user.email]
          end

          it "sends out email with right subject" do
            mail = ActionMailer::Base.deliveries.last
            expect(mail.subject).to eq "Your certification is ready!"
          end

          it "sends out email with certification link" do
            mail = ActionMailer::Base.deliveries.last.body.encoded
            cert = Certificate.first
            expect(mail).to include certificate_path(cert.licence_number)
          end

          it "adds message to the flash info" do
            expect(flash[:info]).to match /We sent.+email.+your certification/m
          end
        end

        context "free enrollment" do
          before do
            Fabricate.times(2, :quiz, course: ruby, published: true)
            Fabricate.times(2,
                            :exam,
                            student: current_user,
                            enrollment: enrollment,
                            passed: true)
            enrollment.update_columns(paid: false)
            patch :complete,
                  id: exam.id,
                  quiz_id: quiz.slug,
                  student_answer_ids: to_ids(ga1)
          end

          it "does not send out email" do
            expect(ActionMailer::Base.deliveries).to be_empty
          end

          it "does not create certificate" do
            expect(Certificate.count).to eq 0
          end
        end
      end
    end

    context "with invalid data" do
      let(:invalid_answer) { Fabricate(:gen_incorrect) }

      before do
        patch :complete,
              id: exam.id,
              quiz_id: quiz.slug,
              student_answer_ids: to_ids(invalid_answer)
      end

      it { is_expected.to render_template :new }
      it { is_expected.to set_the_flash.now[:danger] }

      it "sets the @quiz" do
        expect(assigns(:quiz)).to eq(quiz)
      end

      it "sets the @exam" do
        expect(assigns(:exam)).to eq(exam)
      end

      it "does not update generated answers with student answers" do
        expect(ga1.reload.student_marked).to be nil
        expect(ga2.reload.student_marked).to be nil
        expect(ga3.reload.student_marked).to be nil
        expect(ga4.reload.student_marked).to be nil
      end

      it "does not set the status to completed" do
        expect(exam.reload).to_not be_completed
      end
    end
  end
end
