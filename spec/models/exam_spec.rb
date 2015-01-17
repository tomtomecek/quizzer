require 'spec_helper'

describe Exam do
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_db_index(:quiz_id) }
  it { is_expected.to have_db_index(:student_id) }
end