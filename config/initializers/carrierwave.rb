require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.development? # 開発中もs3使う
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'skate-spot-search'
    config.asset_host = 'https://skate-spot-search.s3.amazonaws.com'
    config.fog_public = false
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAW3ZUVLTQLN2DU66F',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end