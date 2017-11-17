class RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.role = 1
    resource.name = params["user"]["email"].split("@")[0]
    resource.username = params["user"]["email"].split("@")[0]
    resource.slug = params["user"]["email"].split("@")[0]
    resource.save
  end
end
