class PreorderRepository

  def get_all(query_parameters)
    relation = query_parameters.key?('with') ? query_parameters['with'] : false
    page = query_parameters.key?('page') ? query_parameters['page'].to_i : false
    limit = query_parameters.key?('page_size') ? query_parameters['page_size'].to_i : false

    if page and limit
      return Preorder.paginate(:page => page, :limit  => limit)
    end
    
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