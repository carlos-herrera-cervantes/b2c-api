class CardManager

  def create(client)
    created = Card.new(client)
    created if created.save
  end

  def update(id, card)
    finded = Card.find(id)
    finded if finded.update(card)
  end

  def delete(id)
    card = Card.find(id)
    card.destroy
  end

end