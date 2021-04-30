require 'async/await'

class ClientManager < BaseManager
  include Async::Await

  def initialize
    super(Client)
  end
  
end