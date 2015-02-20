require 'spec_helper'

describe LinkedInHelper do
  describe "#linked_in_url" do
    let(:ruby) { Fabricate(:course, title: "Introduction to Ruby") }
    let(:enrollment) { Fabricate(:enrollment, course: ruby, paid: true) }
    let(:certificate) do
      Fabricate(
        :certificate,
        enrollment: enrollment,
        created_at: "Fri, 20 Feb 2015 12:53:15 UTC +00:00".to_datetime
      )
    end
    subject(:url) { helper.linked_in_url(certificate) }

    it "returns url to linked in starts with http://" do
      expect(url.start_with?('http://www.linkedin.com')).to be true
    end

    context "sets url with linked in params" do
      it "sets certification name" do
        expect(url).to match /&pfCertificationName=Introduction%20to%20Ruby/
      end

      it "sets licence number" do
        expect(url).to match /&pfLicenseNo=#{certificate.licence_number}/
      end

      it "sets certificate start date " do
        expect(url).to match /&pfCertStartDate=201502/
      end

      it "sets certification url" do
        expect(url).to match /&pfCertificationUrl=#{URI.encode(certificate_url(certificate.licence_number, format: 'pdf'))}/
      end
    end
  end
end
