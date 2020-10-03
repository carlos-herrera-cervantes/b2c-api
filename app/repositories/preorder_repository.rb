class PreorderRepository

  def get_all
    Preorder.all
  end

  def get_by_id(id)
    Preorder.find(id)
  end

end