class CardRepository

  def get_all(query_parameters)
    relation = query_parameters.key?('with') ? query_parameters['with'] : false
    
    unless relation
      return Card.all
    end

    filter = MongodbModule.build_filter(query_parameters, 'card')
    Card.collection.aggregate(filter)
  end

  def get_by_id(id)
    Card.find(id)
  end

end