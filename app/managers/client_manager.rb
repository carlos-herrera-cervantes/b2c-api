class ClientManager

  def create(client)
    created = Client.new(client)
    
    if created.save
      created
    else
      created.errors
    end
  end

  def update(id, client)
    finded = Client.find(id)
    
    if finded.update(client)
      finded
    else
      finded.errors
    end
  end

  def delete(id)
    client = Client.find(id)
    client.destroy
  end
  
end