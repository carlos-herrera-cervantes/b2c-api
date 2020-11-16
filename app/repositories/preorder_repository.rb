require 'async/await'

class PreorderRepository
  include Async::Await

  async def get_all_async(query_parameters)
    hash = CommonModule.define_query_parameters(query_parameters)
    relation, page, limit, sort = hash.values_at('relation', 'page', 'limit', 'sort')

    if sort
      return Preorder.order_by(CommonModule.define_type_ordering(sort))
    end

    if page and limit
      return Preorder.paginate(:page => page, :limit  => limit)
    end
    
    unless relation
      return Preorder.all
    end

    filter = MongodbModule.build_filter(query_parameters, 'preorder')
    Preorder.collection.aggregate(filter)
  end

  async def get_by_id_async(id)
    Preorder.find(id)
  end

end