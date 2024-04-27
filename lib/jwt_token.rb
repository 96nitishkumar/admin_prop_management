require 'jwt'

module JwtToken
  SECRET = 'EXT30'

# Token Encoded method
  def self.encode_token(user)
    payload = { user_id: user, exp: 10.hours.from_now.to_i }
    JWT.encode(payload, SECRET)
  end

# Token decoded method
  def self.decode_token(token)
      JWT.decode(token, SECRET)
  end
end
