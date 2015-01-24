require "spec_helper"

describe QuizzesController do
  before { set_current_admin }

  describe "GET new" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :new, course_id: 1 }
    end

    it "sets the @quiz" do
      course = Fabricate(:course)
      get :new, course_id: course.slug
      expect(assigns(:quiz)).to be_new_record
      expect(assigns(:quiz)).to be_instance_of Quiz
    end

    it "sets the quiz under course" do
      course = Fabricate(:course)
      get :new, course_id: course.slug
      expect(assigns(:quiz).course).to eq(course)
    end
  end

  describe "POST create" do
    it_behaves_like "require admin sign in" do
      let(:action) { post :create, course_id: 1 }
    end

    context "with valid inputs" do
      let(:course) { Fabricate(:course) }
      before do
        post :create, course_id: course.slug,
                      quiz: {
                        title: "Week 1 - Ruby",
                        description: "Checking knowledge...",
                        published: "0",
                        questions_attributes: [
                          question(question: "1 + 1",
                                   answer: "2",
                                   points: "3"),
                          question(question: "2 + 2",
                                   answer: "4",
                                   points: "3")
                        ]
                      }
      end

      it { is_expected.to redirect_to [:admin, course] }
      it { is_expected.to set_the_flash[:success] }

      it "creates the quiz" do
        expect(Quiz.count).to eq 1
      end

      it "creates the quiz under course" do
        expect(course.quizzes).to include(Quiz.first)
      end

      it "creates the quiz with questions" do
        quiz = course.quizzes.first
        expect(quiz.questions.count).to eq 2
      end

      it "creates the quiz with questions and answers" do
        quiz = course.quizzes.first
        question = quiz.questions.first
        expect(question.answers.count).to eq 5
      end
    end

    context "with invalid inputs" do
      let(:course) { Fabricate(:course) }
      context "invalid quiz" do
        before do
          post :create, course_id: course.slug,
                        quiz: {
                          title: "",
                          description: "",
                          published: "0",
                          questions_attributes: [ 
                            question(question: "1 + 1",
                                     answer: "2",
                                     points: "3")
                          ]
                        }
        end

        it "does not create any from the set" do
          expect(Quiz.count).to eq 0
          expect(Question.count).to eq 0
          expect(Answer.count).to eq 0
        end

        it { is_expected.to render_template :new }
        it { is_expected.to set_the_flash.now[:danger] }

        it "sets the @quiz" do
          expect(assigns(:quiz)).to be_new_record
          expect(assigns(:quiz)).to be_instance_of Quiz
        end

        it "sets the errors on @quiz" do
          expect(assigns(:quiz).errors.any?).to be true
        end
      end

      context "invalid question" do
        before do
          post :create, course_id: course.slug,
                        quiz: {
                          title: "Week 1 quiz",
                          description: "Great quiz ...",
                          published: "0",
                          questions_attributes: [
                            question(question: "", answer: "2", points: "3")
                          ]
                        }
        end

        it "does not create any from the set" do
          expect(Quiz.count).to eq 0
          expect(Question.count).to eq 0
          expect(Answer.count).to eq 0
        end
      end

      context "invalid answer" do
        before do
          post :create, course_id: course.slug,
                        quiz: {
                          title: "Week 1 quiz",
                          description: "Great quiz ...",
                          published: "0",
                          questions_attributes: [
                            question(question: "1 + 1", points: "3")
                          ]
                        }
        end

        it "does not create any from the set" do
          expect(Quiz.count).to eq 0
          expect(Question.count).to eq 0
          expect(Answer.count).to eq 0
        end
      end      
    end
  end
end

def question(options = {})
  content         = options[:question]
  points          = options[:points] || "1"
  correct_count   = options[:correct_count] || 1
  incorrect_count = options[:incorrect_count] || 4
  {
    content: content,
    points: points,
    answers_attributes: answers(options[:answer],
                                correct_count,
                                incorrect_count)
  }
end

def answers(answer, corrent_answers, incorrect_answers)
  arr = []
  corrent_answers.times do
    arr << { content: answer, correct: true }
  end
  incorrect_answers.times do
    arr << { content: "incorrect answer", correct: false }
  end
  arr.shuffle
end
