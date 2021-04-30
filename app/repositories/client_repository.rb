require 'async/await'

class ClientRepository < BaseRepository
  include Async::Await

  def initialize
    super(Client, 'client')
  end

end