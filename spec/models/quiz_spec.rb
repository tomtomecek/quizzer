require "spec_helper"

describe Quiz do
  it { is_expected.to belong_to(:course) }
  it { is_expected.to have_db_index(:course_id) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:passing_percentage) }
  it { is_expected.to validate_presence_of(:questions).
                      with_message('requires at least 1 question.') }
  it { is_expected.to have_many(:exams) }
  it { is_expected.to have_many(:questions).
                      order(:created_at).
                      dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:questions).
                      allow_destroy(true) }

  context "when published" do
    before { subject.stub(:published?).and_return(true) }
    it { is_expected.to validate_numericality_of(:position).only_integer }
  end

  describe "scope .published" do
    it "returns [] if no quiz has been published" do
      Fabricate.times(2, :quiz, published: false)
      expect(Quiz.published).to match_array []
    end

    it "returns an array of multiple published quizzes" do
      quiz1 = Fabricate(:quiz, published: true)
      quiz2 = Fabricate(:quiz, published: true)
      expect(Quiz.published).to match_array [quiz1, quiz2]
    end

    it "returns an array of 1 published quiz" do
      published_quiz = Fabricate(:quiz, published: true)
      Fabricate(:quiz, published: false)
      expect(Quiz.published).to eq [published_quiz]
    end
  end

  describe "#generate_slug" do
    it "creates course with slug based on title" do
      Fabricate(:quiz, title: "Week 1 - Procedural Ruby")
      expect(Quiz.first.slug).to eq "week-1-procedural-ruby"
    end

    it "appends a number to slug if already exists" do
      q1 = Fabricate(:quiz, title: "Week 1 - Procedural Ruby")
      q2 = Fabricate(:quiz, title: "Week 1 - Procedural Ruby")
      expect(q2.slug).to eq "week-1-procedural-ruby-2"
    end

    it "creates a unique slug for many same courses" do
      Fabricate.times(4, :quiz, title: "Week 1 - Procedural Ruby")
      quiz = Fabricate(:quiz, title: "Week 1 - Procedural Ruby")
      expect(quiz.slug).to eq "week-1-procedural-ruby-5"
    end
  end

  describe "#total_score" do
    it "calculates total score for 1 question" do
      quiz = Fabricate(:quiz) do
        questions { [Fabricate(:question, points: 1)] }
      end
      expect(quiz.total_score).to eq(1)
    end

    it "calculates total score for multiple questions" do
      quiz = Fabricate(:quiz) do
        questions do
          [
            Fabricate(:question, points: 1),
            Fabricate(:question, points: 2),
            Fabricate(:question, points: 5)
          ]
        end
      end
      expect(quiz.total_score).to eq(8)
    end
  end

  describe "#passing_score" do
    it "returns passing_score for quiz" do
      quiz = Fabricate.build(:quiz, passing_percentage: 60)
      quiz.stub(:total_score).and_return(10)
      expect(quiz.passing_score).to eq 6
    end

    it "returns float" do
      quiz = Fabricate.build(:quiz, passing_percentage: 60)
      quiz.stub(:total_score).and_return(10)
      expect(quiz.passing_score).to be_kind_of Float
    end
  end

  describe "#previous" do
    let(:ruby) { Fabricate(:course) }
    it "returns previous published quiz" do
      quiz1 = Fabricate(:quiz, course: ruby, published: true, position: 1)
      Fabricate(:quiz, course: ruby, published: false)
      quiz2 = Fabricate(:quiz, course: ruby, published: true, position: 2)
      expect(quiz2.previous).to eq quiz1
    end

    it "returns nil if there is no other published quiz" do
      quiz1 = Fabricate(:quiz, course: ruby, published: false)
      quiz2 = Fabricate(:quiz, course: ruby, published: true, position: 1)
      expect(quiz2.previous).to be nil
    end

    it "returns previous quiz in chain of published quizzes" do
      quiz1 = Fabricate(:quiz, course: ruby, published: true, position: 1)
      quiz2 = Fabricate(:quiz, course: ruby, published: true, position: 2)
      quiz3 = Fabricate(:quiz, course: ruby, published: true, position: 3)
      expect(quiz3.previous).to eq quiz2
      expect(quiz3.previous).to_not eq quiz1
    end
  end

  describe "#normalize_position" do
    it "sets position when published is set to true" do
      quiz = Fabricate(:quiz, published: true)
      expect(quiz.position).to eq 1
    end

    it "clears position when published is set to false" do
      quiz = Fabricate(:quiz, published: false)
      expect(quiz.position).to eq nil
    end

    it "sets position when multiple quizzes are published" do
      ruby = Fabricate(:course)
      Fabricate.times(5, :quiz, course: ruby, published: true)
      expect(Quiz.last.position).to eq 5
    end
  end
end
