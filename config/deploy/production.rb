set :stage,           :production
server '103.77.160.145', user: 'deploy', roles: %w{web app db}
set :rails_env, 'production'
set :rack_env, 'production'
set :puma_env, 'production'
set :deploy_to, '/home/deploy/nmd_cms'