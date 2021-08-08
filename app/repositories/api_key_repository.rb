require 'async/await'
require 'securerandom'

class ApiKeyRepository < BaseRepository
  include Async::Await

  def initialize
    super(ApiKey, 'api_key')
  end

  def generate_api_key
    SecureRandom.base64.tr('+/=', 'Qrt')
  end

end