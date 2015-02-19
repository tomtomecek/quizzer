WickedPdf.config do |config|  
  if Rails.env.production? || Rails.env.staging? then
    config.exe_path = Rails.root.to_s + '/bin/wkhtmltopdf'
  else  
    if /darwin/ =~ RUBY_PLATFORM then
      config.exe_path = '/usr/local/bin/wkhtmltopdf'
    else
      raise "UnableToLocateWkhtmltopdf"
    end
  end
end