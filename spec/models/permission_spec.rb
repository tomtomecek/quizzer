require 'spec_helper'

describe Permission do
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to belong_to(:enrollment) }
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_db_index(:student_id) }
  it { is_expected.to have_db_index(:quiz_id) }
end
