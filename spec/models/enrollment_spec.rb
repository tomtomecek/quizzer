require 'spec_helper'

describe Enrollment do
  it { is_expected.to belong_to(:course) }
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to have_many(:exams) }
  it { is_expected.to have_one(:certificate) }
  it "validates uniqueness of Enrollment towards student and course" do
    is_expected.to validate_uniqueness_of(:student_id).
      scoped_to(:course_id).
      with_message('You have already enrolled.')
  end

  context "validates acceptance of honor code" do
    it "is valid when user accepts" do
      enrollment = Fabricate.build(:enrollment, honor_code: "1")
      expect(enrollment).to be_valid
    end

    it "is invalid when user does not accept" do
      enrollment = Fabricate.build(:enrollment, honor_code: "0")
      expect(enrollment).to be_invalid
    end
  end

  describe "#passed_exams" do
    it "returns an array of multiple exams" do
      enrollment = Fabricate(:enrollment)
      exam1 = Fabricate(:exam, enrollment: enrollment, passed: true)
      exam2 = Fabricate(:exam, enrollment: enrollment, passed: true)
      Fabricate(:exam, enrollment: enrollment, passed: false)
      expect(enrollment.passed_exams).to eq [exam1, exam2]
    end
  end

  describe "#is_completed?" do
    let(:ruby) { Fabricate(:course, published: true, min_quiz_count: 3) }
    let(:student) { Fabricate(:user) }
    let(:enrollment) { Fabricate(:enrollment, student: student, course: ruby) }

    it "returns true when enrollment met completion rules" do
      Fabricate.times(3, :quiz, published: true, course: ruby)
      Fabricate.times(3,
                      :exam,
                      enrollment: enrollment,
                      student: student,
                      passed: true)
      expect(enrollment.is_completed?).to be true
    end

    it "returns false when enrollment did not meet completion rules" do
      Fabricate.times(4, :quiz, published: true, course: ruby)
      Fabricate.times(3,
                      :exam,
                      enrollment: enrollment,
                      student: student,
                      passed: true)
      expect(enrollment.is_completed?).to be false
    end
  end

  describe "#completion_percentage" do
    let(:ruby) { Fabricate(:course, published: true) }
    let(:alice) { Fabricate(:user) }
    let(:enr) { Fabricate(:enrollment, student: alice, course: ruby) }

    it "returns 0 if student has not passed any exam" do
      Fabricate.times(4, :quiz, course: ruby, published: true)
      expect(enr.completion_percentage).to eq 0
    end

    it "returns 50 if student passed 2 exams from 4 quizzes" do
      Fabricate.times(4, :quiz, course: ruby, published: true)
      Fabricate.times(2, :exam, student: alice, enrollment: enr, passed: true)
      expect(enr.completion_percentage).to eq 50
    end

    it "returns 66 if student passed 4 exams from 6 quizzes" do
      Fabricate.times(6, :quiz, course: ruby, published: true)
      Fabricate.times(4, :exam, student: alice, enrollment: enr, passed: true)
      expect(enr.completion_percentage).to eq 66
    end

    it "returns 100 if student passed 4 exams from 4 quizzes" do
      Fabricate.times(4, :quiz, course: ruby, published: true)
      Fabricate.times(4, :exam, student: alice, enrollment: enr, passed: true)
      expect(enr.completion_percentage).to eq 100
    end
  end
end
