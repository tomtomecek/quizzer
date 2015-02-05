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
                        questions_attributes: {
                          "1" => question(question: "1 + 1",
                                          answer: "2",
                                          points: "3"),
                          "2" => question(question: "2 + 2",
                                          answer: "4",
                                          points: "4"),
                          "3" => question(question: "3 + 3",
                                          answer: "6",
                                          points: "10")
                        }
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
        expect(quiz.questions.count).to eq 3
      end

      it "creates the quiz with questions and answers" do
        quiz = course.quizzes.first
        question1 = quiz.questions.first
        question2 = quiz.questions.second
        question3 = quiz.questions.last
        expect(question1.answers.count).to eq 5
        expect(question2.answers.count).to eq 5
        expect(question3.answers.count).to eq 5
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
                          questions_attributes: {
                            "1" => question(question: "1 + 1",
                                            answer: "2",
                                            points: "3")
                          }
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
                          questions_attributes: {
                            "1" => question(question: "",
                                            answer: "2",
                                            points: "3")
                          }
                        }
        end

        it "does not create any from the set" do
          expect(Quiz.count).to eq 0
          expect(Question.count).to eq 0
          expect(Answer.count).to eq 0
        end
      end

      context "answer limit reached" do
        before do
          post :create, course_id: course.slug,
                        quiz: {
                          title: "Week 1 - Ruby",
                          description: "Checking knowledge...",
                          published: "0",
                          questions_attributes: {
                            "1" => question(question: "How much is 1 + 1?",
                                            points: "3",
                                            answer: "2",
                                            correct_count: 7,
                                            incorrect_count: 4)
                          }
                        }
        end

        it { is_expected.to set_the_flash.now[:info] }
        it { is_expected.to render_template :new }
      end
    end
  end

  describe "GET edit" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :edit, id: 1 }
    end

    it "sets the @quiz" do
      quiz = Fabricate(:quiz)
      get :edit, id: quiz.slug
      expect(assigns(:quiz)).to eq quiz
    end
  end

  describe "PATCH update" do
    it_behaves_like "require admin sign in" do
      let(:action) { patch :update, id: 1 }
    end

    context "with valid data" do
      let(:quiz) { Fabricate(:quiz) }
      let(:question) { quiz.questions.first }

      before do
        patch :update, id: quiz.slug, quiz: {
          title: "Pro ruby",
          description: "For advanced",
          published: "1",
          questions_attributes: [
            {
              _destroy: "false",
              id: question.id,
              content: "A new question",
              points: "10",
              answers_attributes: [
                {
                  _destroy: "false",
                  id: question.answers[0].id,
                  content: "updated answer",
                  correct: true
                },
                {
                  _destroy: "false",
                  id: question.answers[1].id,
                  content: "correct answer",
                  correct: true
                },
                {
                  _destroy: "false",
                  id: question.answers[2].id,
                  content: "correct answer",
                  correct: true
                },
                {
                  _destroy: "false",
                  id: question.answers[3].id,
                  content: "correct answer",
                  correct: true
                }
              ]
            }
          ]
        }
      end

      it { is_expected.to redirect_to admin_course_url(quiz.course) }
      it { is_expected.to set_the_flash[:success] }

      it "updates the quiz" do
        expect(quiz.reload.title).to eq("Pro ruby")
        expect(quiz.description).to eq("For advanced")
        expect(quiz).to be_published
      end

      it "updates a question" do
        expect(question.reload.content).to eq("A new question")
        expect(question.points).to eq(10)
      end

      it "updates an answer" do
        expect(Answer.first.content).to eq("updated answer")
      end
    end

    context "with invalid data" do
      let(:quiz) { Fabricate(:quiz) }
      let(:question) { quiz.questions.first }

      context "with quiz" do
        before do
          patch :update, id: quiz.slug, quiz: {
            title: "Pro Ruby",
            description: "",
            published: "1",
            questions_attributes: []
          }
        end

        it { expect(response).to render_template :edit }
        it { is_expected.to set_the_flash.now[:danger] }
        it "sets the @quiz" do
          expect(assigns(:quiz)).to eq quiz
        end

        it "does not update the quiz" do
          expect(quiz.reload.title).to_not eq("Pro Ruby")
        end
      end

      context "with question" do
        before do
          patch :update, id: quiz.slug, quiz: {
            title: "Pro Ruby",
            description: "For advanced",
            published: "1",
            questions_attributes: [{ _destroy: "1", id: question.id }]
          }
        end

        it "does not update quiz, questions, answers" do
          expect(quiz.title).to_not eq("Pro Ruby")
          expect(question).to be
          answer = question.answers.first
          expect(answer.content).to_not eq("updated answer")
        end
      end

      context "with answer" do
        before do
          patch :update, id: quiz.slug, quiz: {
            title: "Pro ruby",
            description: "For advanced",
            published: "1",
            questions_attributes: [
              {
                _destroy: "false",
                id: question.id,
                content: "A new question",
                points: "10",
                answers_attributes: [
                  {
                    _destroy: "false",
                    id: question.answers[0].id,
                    content: "updated answer",
                    correct: true
                  },
                  { _destroy: "1", id: question.answers[1].id },
                  { _destroy: "1", id: question.answers[2].id },
                  { _destroy: "1", id: question.answers[3].id }
                ]
              }
            ]
          }
        end

        it "does not update the answer" do
          expect(Answer.first.content).to_not eq("updated answer")
          expect(Answer.count).to eq 4
        end
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require admin sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets the @quiz" do
      quiz = Fabricate(:quiz)
      get :show, id: quiz.slug
      expect(assigns(:quiz)).to eq quiz
    end
  end

end

def question(options = {})
  content   = options[:question]
  points    = options[:points] || "1"
  correct   = options[:correct_count] || 1
  incorrect = options[:incorrect_count] || 4
  {
    content: content,
    points: points,
    answers_attributes: answers(options[:answer], correct, incorrect)
  }
end

def answers(answer, correct_answers, incorrect_answers)
  hash = {}

  correct_answers.times do |n|
    hash["#{n}"] = { content: answer, correct: true }
  end

  incorrect_answers.times do |n|
    key = correct_answers + n
    hash["#{key}"] = { content: "incorrect answer", correct: false }
  end

  hash
end
