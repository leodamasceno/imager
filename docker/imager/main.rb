require 'sinatra'
require 'aws-sdk-s3'
require 'mini_magick'
require 'yaml'

# Read app config
config = YAML.load_file('config.yaml')

bucket_name = config['config']['s3']['bucket_name']
local_path = config['config']['s3']['local_path']

# Check the authentication type and use the AWS SDK to create session
case config['config']['auth']['type']
when 'credentials'
  s3 = Aws::S3::Client.new(region: 'us-east-2')
when 'role'
  role_arn = config['config']['auth']['arn']
  role_credentials = Aws::AssumeRoleCredentials.new(
    client: Aws::STS::Client.new,
    role_session_name: 'imager-tmp-session',
    role_arn: role_arn
  )

  s3 = Aws::S3::Client.new(credentials: role_credentials)
else
  puts 'This authentication type is not valid. Please check your config.yaml' 
end


# Get HTTP request, download and resize image
get '/*' do
  file = request.fullpath.split("?")[0].split("/")[1]
  size = request.fullpath.split("?")[1]
  format = request.fullpath.split("?")[0].split(".")[1]
  download = s3.get_object({ bucket: bucket_name, key: file, response_target: "#{local_path}/#{file}" })
  puts "Downloading object #{file}, size #{size} from bucket #{bucket_name}"
  image = MiniMagick::Image.new(
    "#{local_path}/#{file}"
  )
  puts "Resizing image from #{image.dimensions} to #{size}"
  image.resize "#{size}"
  send_file "#{local_path}/#{file}", :filename => file, :type => 'Application/octet-stream'
end


