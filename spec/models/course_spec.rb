require "spec_helper"

describe Course do
  it { is_expected.to have_many(:quizzes).order(:created_at) }
  it { is_expected.to have_many(:enrollments) }
  it { is_expected.to validate_presence_of(:description) }

  describe "#generate_slug" do
    it "creates course with slug based on title" do
      Fabricate(:course, title: "Introduction to Ruby")
      expect(Course.first.slug).to eq "introduction-to-ruby"
    end

    it "appends a number to slug if already exists" do
      c1 = Fabricate(:course, title: "Introduction to Ruby")
      c2 = Fabricate(:course, title: "Introduction to Ruby")
      expect(c2.slug).to eq "introduction-to-ruby-2"
    end

    it "creates a unique slug for many same courses" do
      Fabricate.times(4, :course, title: "Introduction to Ruby")
      course = Fabricate(:course, title: "Introduction to Ruby")
      expect(course.slug).to eq "introduction-to-ruby-5"
    end
  end

  describe "#starting_quiz" do
    let(:course) { Fabricate(:course) }

    it "returns published quiz with position 1" do
      quiz = Fabricate(:quiz, published: true, course: course, position: 1)
      expect(course.starting_quiz).to eq quiz
    end

    it "does not return unpublished quiz" do
      quiz = Fabricate(:quiz, published: false, course: course)
      expect(course.starting_quiz).to_not be quiz
    end
  end

  describe "#published_quizzes" do
    let(:course) { Fabricate(:course) }
    it "returns array of published quizzes" do
      quiz1 = Fabricate(:quiz, published: true, course: course)
      quiz2 = Fabricate(:quiz, published: true, course: course)
      Fabricate(:quiz, published: false, course: course)
      expect(course.published_quizzes).to match_array [quiz1, quiz2]
    end

    it "returns [] for no published quizzes" do
      Fabricate(:quiz, published: false, course: course)
      expect(course.published_quizzes).to match_array []
    end
  end
end
