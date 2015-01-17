require 'spec_helper'

describe Question do
  it { is_expected.to belong_to(:quiz) }
  it { is_expected.to have_many(:answers) }
end