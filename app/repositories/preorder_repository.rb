require 'async/await'

class PreorderRepository < BaseRepository
  include Async::Await

  def initialize
    super(Preorder, 'preorder')
  end

end