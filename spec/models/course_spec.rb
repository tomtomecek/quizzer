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
end
