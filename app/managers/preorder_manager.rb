class PreorderManager

  def create(preorder)
    created = Preorder.new(preorder)
    
    if created.save
      created
    else
      created.errors
    end
  end

  def update(id, preorder)
    finded = Preorder.find(id)
    
    if finded.update(preorder)
      finded
    else
      finded.errors
    end
  end

  def delete(id)
    preorder = Preorder.find(id)
    preorder.destroy
  end

end