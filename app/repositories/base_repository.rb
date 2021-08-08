require 'async/await'

class BaseRepository
  include Async::Await

  def initialize(model, model_name)
    @model = model
    @model_name = model_name
  end

  async def get_all_async(hash)
    relation, page, limit, sort, filter = hash.values_at(
      'relation',
      'page',
      'limit',
      'sort',
      'filter'
    )
    keys_relations = RelationsModule.get_relation_by_model(@model_name)

    pipeline = MongodbModule.build_filter(relation, keys_relations)
    pipeline.append({ '$sort' => sort })
    pipeline.append({ '$skip' => page })
    pipeline.append({ '$limit' => limit })
    pipeline.append({ '$match' => filter })

    @model.collection.aggregate(pipeline)
  end

  async def get_by_id_async(id)
    @model.find(id)
  end

  async def get_one_async(filter)
    @model.find_by(filter)
  end

  async def count_async(filter = {})
    @model.where(filter).count
  end

end