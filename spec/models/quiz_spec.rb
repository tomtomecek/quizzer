require 'spec_helper'

describe Quiz do
  it { is_expected.to belong_to(:course) }
  it { is_expected.to have_db_index(:course_id) }
  it { is_expected.to validate_presence_of(:title) }

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
end