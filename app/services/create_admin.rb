class CreateAdmin
  def call
    user = User.find_or_create_by!(email: ENV.fetch("admin_name")) do |user|
      user.password = ENV.fetch("admin_password")
      user.password_confirmation = ENV.fetch("admin_password")
      user.name = ENV.fetch("admin_name")
      user.username = ENV.fetch("admin_name")
      user.slug = ENV.fetch("admin_name")
      user.role = :admin
    end
  end
end