set :stage,           :staging
server '103.77.160.145', user: 'deploy', roles: %w{web app db}
set :rails_env, 'staging'
set :rack_env, 'staging'
set :puma_env, 'staging'
set :deploy_to, '/home/deploy/nmd_cms_staging'

set :default_env, {
    admin_name: ENV["admin_name"],
    admin_password: ENV["admin_password"],
    db_name: ENV["db_name"],
    db_username: ENV["db_username"],
    db_postgres: ENV["db_postgres"],
    db_host: ENV["db_host"],
    db_port: ENV["db_port"],
    SECRET_KEY_BASE: ENV["SECRET_KEY_BASE"]
}