class ClientRepository

  def get_all(query_parameters)
    hash = CommonModule.define_query_parameters(query_parameters)
    relation, page, limit, sort = hash.values_at('relation', 'page', 'limit', 'sort')
    
    if sort
      return Client.order_by(CommonModule.define_type_ordering(sort))
    end

    if page and limit
      return Client.paginate(:page => page, :limit  => limit)
    end
    
    unless relation
      return Client.all
    end

    filter = MongodbModule.build_filter(query_parameters, 'client')
    Client.collection.aggregate(filter)
  end

  def get_by_id(id)
    Client.find(id)
  end
  
  def get_one(filter)
    Client.find_by(filter)
  end

end