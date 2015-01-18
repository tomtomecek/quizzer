require 'spec_helper'

describe Answer do
  it { is_expected.to belong_to(:question) }
end