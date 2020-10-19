module MongodbModule
  extend self
  
  def build_filter(query_parameters, base)
    relation = query_parameters.key?('with') ? query_parameters['with'] : false
    entities = relation ? relation.split(',') : false
    keys_relations = RelationsModule.get_relation_by_model(base)
      
    result = entities.map do |entity|
      selected_key = keys_relations[entity]
      {
        '$lookup' => {
          from: entity,
          localField: selected_key['localField'],
          foreignField: selected_key['foreignField'],
          as: entity
        }
      }
    end
  end
  
end