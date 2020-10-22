class PreorderRepository

  def get_all(query_parameters)
    relation = query_parameters.key?('with') ? query_parameters['with'] : false
    
    unless relation
      return Preorder.all
    end

    filter = MongodbModule.build_filter(query_parameters, 'preorder')
    Preorder.collection.aggregate(filter)
  end

  def get_by_id(id)
    Preorder.find(id)
  end

end