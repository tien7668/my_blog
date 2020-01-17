module API::Auth

  def authenticate!
    begin
      payload, header = JsonWebToken.valid?(token)
      @current_user = User.find_by(id: payload["user_id"])
    rescue
      raise TT::Error.new('UNAUTHENTICATED', 'Unauthorized')
    end
  end

  def current_user
    @current_user ||= authenticate!
  end

  def token
    request.headers['Authorization'].split(' ').last
  end

end