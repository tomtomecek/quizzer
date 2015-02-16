require 'spec_helper'

describe User do
  it { is_expected.to have_many(:exams).with_foreign_key(:student_id) }
  it { is_expected.to have_many(:enrollments).with_foreign_key(:student_id) }
  it { is_expected.to have_many(:permissions).with_foreign_key(:student_id) }
  it { is_expected.to have_many(:certificates).with_foreign_key(:student_id) }

  describe ".from_omniauth" do
    let(:auth) { OmniAuth.config.mock_auth[:github] }

    it "finds a user by provider and uid" do
      Fabricate(:user, provider: "github", uid: "12345")
      user = User.from_omniauth(auth)
      expect(User.first).to eq user
    end

    it "creates a user from omniauth hash" do
      User.from_omniauth(auth)
      expect(User.count).to eq(1)
    end
  end

  describe "#has_enrolled?(course)" do
    let(:course) { Fabricate(:course) }

    it "returns true if student has enrolled course" do
      alice = Fabricate(:user)
      Fabricate(:enrollment, course: course, student: alice)
      expect(alice.has_enrolled?(course)).to be true
    end

    it "returns false if student didnt enroll course" do
      alice = Fabricate(:user)
      jake = Fabricate(:user)
      Fabricate(:enrollment, course: course, student: jake)
      expect(alice.has_enrolled?(course)).to be false
    end
  end

  describe "#has_permission?(quiz)" do
    it "returs true when student has permission on quiz" do
      student = Fabricate(:user)
      quiz = Fabricate(:quiz)
      Fabricate(:permission, student: student, quiz: quiz)
      expect(student.has_permission?(quiz)).to be true
    end

    it "returns false when student does not have permission on quiz" do
      student = Fabricate(:user)
      quiz = Fabricate(:quiz)
      Fabricate(:permission, student: student)
      expect(student.has_permission?(quiz)).to be false
    end
  end
end
