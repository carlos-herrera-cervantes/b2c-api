require 'async/await'

class CardRepository < BaseRepository
  include Async::Await

  def initialize
    super(Card, 'card')
  end

end