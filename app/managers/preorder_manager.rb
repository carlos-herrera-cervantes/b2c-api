require 'async/await'

class PreorderManager
  include Async::Await

  async def create_async(preorder)
    created = Preorder.new(preorder)
    
    if created.save
      created
    else
      created.errors
    end
  end

  async def update_async(id, preorder)
    finded = Preorder.find(id)
    
    if finded.update(preorder)
      finded
    else
      finded.errors
    end
  end

  async def delete_async(id)
    preorder = Preorder.find(id)
    preorder.destroy
  end

end