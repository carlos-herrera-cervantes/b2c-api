class JsonWebToken
  SECRET_KEY = ENV['SECRET_TOKEN_KEY']
  
  def self.encode(payload, expiration = 24.hours.from_now)
    payload[:expiration] = expiration.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end