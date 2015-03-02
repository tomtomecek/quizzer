class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    if Rails.env.test?
      'tmp'
    elsif Rails.env.development?
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      'public/uploads'
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process resize_to_fill: [667, 320]

  version :certificate do
    process resize_to_fit: [460, 322]
  end
end
