CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = ENV['S3_BUCKET_NAME']
    config.aws_acl    = :public_read
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

    config.aws_credentials = {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
