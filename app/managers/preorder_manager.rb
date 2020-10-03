class PreorderManager

  def create(preorder)
    created = Preorder.new(preorder)
    created if created.save
  end

  def update(id, preorder)
    finded = Preorder.find(id)
    finded if finded.update(preorder)
  end

  def delete(id)
    preorder = Preorder.find(id)
    preorder.destroy
  end

end