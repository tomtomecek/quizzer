WickedPdf.config do |config|
  if Rails.env.production? || Rails.env.staging?
    config.exe_path = "#{Rails.root}/bin/wkhtmltopdf"
  else
    if /darwin/ =~ RUBY_PLATFORM
      config.exe_path = "/usr/local/bin/wkhtmltopdf"
    else
      raise "UnableToLocateWkhtmltopdf"
    end
  end
end
