require 'async/await'

class ClientManager
  include Async::Await

  async def create_async(client)
    created = Client.new(client)
    
    if created.save
      created
    else
      created.errors
    end
  end

  async def update_async(id, client)
    finded = Client.find(id)
    
    if finded.update(client)
      finded
    else
      finded.errors
    end
  end

  async def delete_async(id)
    client = Client.find(id)
    client.destroy
  end
  
end