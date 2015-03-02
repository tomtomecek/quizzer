require "spec_helper"

describe Course do
  it { is_expected.to belong_to(:instructor).class_name("Admin") }
  it { is_expected.to have_many(:quizzes).order(:created_at) }
  it { is_expected.to have_many(:enrollments) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price_cents) }
  it { is_expected.to validate_presence_of(:min_quiz_count) }
  it "validates min quiz count" do
    is_expected.to validate_numericality_of(:min_quiz_count).
      only_integer.
      is_greater_than_or_equal_to(3)
  end
  it "validates price in cents" do
    is_expected.to validate_numericality_of(:price_cents).
      only_integer.
      is_greater_than(0)
  end

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

  describe "#price_dollars=" do
    it "converts dollars to cents" do
      ruby = Course.new(price_dollars: "19.99")
      expect(ruby.price_cents).to eq 1999
    end
  end

  describe "#price_dollars" do
    it "converts cents to dollars" do
      ruby = Course.new(price_cents: 1999)
      expect(ruby.price_dollars).to eq 19.99
    end

    it "returns nil if price_cents is nil" do
      ruby = Course.new
      expect(ruby.price_dollars).to eq nil
    end
  end
end
