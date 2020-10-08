class CardManager

  def create(client)
    created = Card.new(client)
    
    if created.save
      created
    else
      created.errors
    end
  end

  def update(id, card)
    finded = Card.find(id)
    
    if finded.update(card)
      finded
    else
      finded.errors
    end
  end

  def delete(id)
    card = Card.find(id)
    card.destroy
  end

end