if Rails.env == "production"
  S3_CREDENTIALS = {
    :bucket => ENV['S3_BUCKET_NAME'],
    :access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']
  }
  AWS.config({
    :access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']
  })
else
  S3_CREDENTIALS = YAML.load_file(Rails.root.join("config/s3.yml"))
  AWS.config({
    :access_key_id      => S3_CREDENTIALS["development"]["AWS_ACCESS_KEY_ID"],
    :secret_access_key  => S3_CREDENTIALS["development"]["AWS_SECRET_ACCESS_KEY"]
  })
end