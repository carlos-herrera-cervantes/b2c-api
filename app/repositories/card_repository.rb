class CardRepository

  def get_all(query_parameters)
    relation = query_parameters.key?('with') ? query_parameters['with'] : false
    page = query_parameters.key?('page') ? query_parameters['page'].to_i : false
    limit = query_parameters.key?('page_size') ? query_parameters['page_size'].to_i : false

    if page and limit
      return Card.paginate(:page => page, :limit  => limit)
    end
    
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