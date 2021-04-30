require 'async/await'

class CardManager < BaseManager
  include Async::Await

  def initialize
    super(Card)
  end

end