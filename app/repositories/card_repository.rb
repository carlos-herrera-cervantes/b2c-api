class CardRepository

  def get_all(query_parameters)
    hash = CommonModule.define_query_parameters(query_parameters)
    relation, page, limit, sort = hash.values_at('relation', 'page', 'limit', 'sort')

    if sort
      return Card.order_by(CommonModule.define_type_ordering(sort))
    end

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