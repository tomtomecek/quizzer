require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers
  let(:course) { Fabricate(:course) }
  let(:uploader) { ImageUploader.new(:course, :image_path) }

  before do
    ImageUploader.enable_processing = true
    uploader.store!(File.open(File.join(Rails.root, "\
spec/support/images/ruby_on_rails.jpg")))
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  context 'the certificate version' do
    it "scales down a course image to be exactly 460 by 322 pixels" do
      expect(uploader.certificate).to have_dimensions(460, 322)
    end
  end

  context 'the normal version' do
    it "scale down a course image to fit within 667 by 320 pixels" do
      expect(uploader).to be_no_larger_than(667, 320)
    end
  end
end
