class ClientManager

  def create(client)
    created = Client.new(client)
    created if created.save
  end

  def update(id, client)
    finded = Client.find(id)
    finded if finded.update(client)
  end

  def delete(id)
    client = Client.find(id)
    client.destroy
  end
  
end