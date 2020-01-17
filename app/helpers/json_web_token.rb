class JsonWebToken
  def self.encode(payload)
    # payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.valid?(token)
    begin
      JWT.decode(token, Rails.application.secrets.secret_key_base)
    end
  end
end