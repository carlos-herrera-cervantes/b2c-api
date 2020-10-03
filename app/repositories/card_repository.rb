class CardRepository

  def get_all
    Card.all
  end

  def get_by_id(id)
    Card.find(id)
  end

end