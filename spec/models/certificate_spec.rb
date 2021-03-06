require 'spec_helper'

describe Certificate do
  it { is_expected.to belong_to(:enrollment) }
  it { is_expected.to belong_to(:student).class_name("User") }
  it { is_expected.to delegate_method(:course).to(:enrollment) }

  describe "#generate licence number" do
    it "creates certificate with licence number" do
      cert = Fabricate(:certificate)
      expect(cert.licence_number).to_not be nil
    end

    it "creates certificate with uniq licence number" do
      certifications = Fabricate.times(100, :certificate)
      expect(certifications.map(&:licence_number).uniq.size).to eq 100
    end
  end

  describe "#file_name" do
    it "returns file name for pdf" do
      alice = Fabricate(:user, username: "alicewang")
      cert = Fabricate(:certificate,
                       student: alice,
                       created_at: "Thu, 19 Feb 2015 23:44:49 UTC +00:00".to_datetime)
      expect(cert.file_name).to eq "certificate_alicewang_2015-02-19"
    end
  end
end
