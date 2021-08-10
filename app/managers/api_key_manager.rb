require 'async/await'

class ApiKeyManager < BaseManager
  include Async::Await

  def initialize
    super(ApiKey)
  end
  
end