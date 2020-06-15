set :stage,           :production
server '103.77.160.145', user: 'deploy', roles: %w{web app db}
set :rails_env, 'production'
set :rack_env, 'production'
set :puma_env, 'production'

set :branch, :nmd_cms
set :deploy_to, '/home/deploy/nmd_cms'