class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :resource, only: [:new, :edit, :show]
end
