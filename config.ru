# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'grape/jbuilder'

use Rack::Config do |env|
  env['api.tilt.root'] = Rails.root.join 'app', 'views', 'api', 'v1'
end
run Rails.application
