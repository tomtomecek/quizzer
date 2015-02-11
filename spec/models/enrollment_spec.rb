require 'spec_helper'

describe Enrollment do
  it { is_expected.to belong_to(:course) }
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to have_many(:exams) }

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
end
