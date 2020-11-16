require 'async/await'

class ClientRepository
  include Async::Await

  async def get_all_async(query_parameters)
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

  async def get_by_id_async(id)
    Client.find(id)
  end
  
  async def get_one_async(filter)
    Client.find_by(filter)
  end

end