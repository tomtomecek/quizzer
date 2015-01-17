require 'spec_helper'

describe Quiz do
  it { is_expected.to belong_to(:course) }
  it { is_expected.to have_db_index(:course_id) }
end