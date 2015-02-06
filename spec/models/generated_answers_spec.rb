require 'spec_helper'

describe GeneratedAnswer do
  it { is_expected.to belong_to(:generated_question) }
  it { is_expected.to belong_to(:answer) }
  it { is_expected.to have_db_index(:answer_id) }
  it { is_expected.to have_db_index(:generated_question_id) }
end
