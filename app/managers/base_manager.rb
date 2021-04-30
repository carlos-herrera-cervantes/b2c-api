require 'async/await'

class BaseManager
  include Async::Await

  def initialize(model)
    @model = model
  end

  async def create_async(doc)
    created = @model.new(doc)
    
    if created.save
      created
    else
      created.errors
    end
  end

  async def update_async(id, doc)
    finded = @model.find(id)
    
    if finded.update(doc)
      finded
    else
      finded.errors
    end
  end

  async def delete_async(id)
    doc = @model.find(id)
    doc.destroy
  end

end