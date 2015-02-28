class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    Rails.env.test? ? '/tmp/test' : '/tmp/development'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process resize_to_fill: [667, 320]

  version :certificate do
    process resize_to_fill: [460, 322]
  end
end
