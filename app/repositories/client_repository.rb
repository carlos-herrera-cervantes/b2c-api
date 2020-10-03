class ClientRepository

  def get_all
    Client.all
  end

  def get_by_id(id)
    Client.find(id)
  end
  
end