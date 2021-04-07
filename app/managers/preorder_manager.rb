require 'async/await'

class PreorderManager < BaseManager
  include Async::Await

  def initialize
    super(Preorder)
  end

end