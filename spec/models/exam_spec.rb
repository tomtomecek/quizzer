require 'spec_helper'

describe Exam do
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_db_index(:quiz_id) }
  it { is_expected.to have_db_index(:student_id) }

  it "creates an exam with student answer ids empty array if no answer" do
    Fabricate(:exam)
    expect(Exam.first.student_answer_ids).to eq []
  end
end