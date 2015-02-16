require 'spec_helper'

describe Certificate do
  it { is_expected.to belong_to(:enrollment) }
  it { is_expected.to belong_to(:student).class_name("User") }
end
