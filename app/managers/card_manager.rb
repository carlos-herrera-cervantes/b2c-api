require 'async/await'

class CardManager
  include Async::Await

  async def create_async(client)
    created = Card.new(client)
    
    if created.save
      created
    else
      created.errors
    end
  end

  async def update_async(id, card)
    finded = Card.find(id)
    
    if finded.update(card)
      finded
    else
      finded.errors
    end
  end

  async def delete_async(id)
    card = Card.find(id)
    card.destroy
  end

end