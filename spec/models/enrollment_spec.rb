require 'spec_helper'

describe Enrollment do
  it { is_expected.to belong_to(:course) }
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to have_many(:exams) }
  it { is_expected.to have_one(:certificate) }

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
    let(:ruby) { Fabricate(:course) }
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
end
