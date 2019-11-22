# CarrierWave.configure do |config|
#   config.fog_provider    = 'fog/aws'
#   config.fog_credentials = {
#     provider:              'AWS',
#     aws_access_key_id:     ENV['AWS_S3_ACCESS_KEY_ID'],
#     aws_secret_access_key: ENV['AWS_S3_SECRET'],
#     region:                ENV['AWS_REGION']
#   }
#   config.fog_directory   = ENV['AWS_S3_BUCKET_NAME']
#   config.fog_public      = true
#   config.fog_attributes  = { 'Cache-Control' => "max-age=#{1000.day.to_i}" }
# end
