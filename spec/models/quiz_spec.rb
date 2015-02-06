require "spec_helper"

describe Quiz do
  it { is_expected.to belong_to(:course) }
  it { is_expected.to have_db_index(:course_id) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:questions).
                      with_message('requires at least 1 question.') }
  it { is_expected.to have_many(:exams) }
  it do
    is_expected.to have_many(:questions).
                     order(:created_at).
                     dependent(:destroy)
  end
  it do
    is_expected.to accept_nested_attributes_for(:questions).allow_destroy(true)
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
        questions { [Fabricate.build(:question, points: 1)] }
      end
      expect(quiz.total_score).to eq(1)
    end

    it "calculates total score for multiple questions" do
      quiz = Fabricate(:quiz) do
        questions do
          [
            Fabricate.build(:question, points: 1),
            Fabricate.build(:question, points: 2),
            Fabricate.build(:question, points: 5)
          ]
        end
      end
      expect(quiz.total_score).to eq(8)
    end
  end
end
