module MongodbModule
  extend self
  
  def build_filter(relation, keys_relations)
    unless relation
      return []
    end

    entities = relation&.split(',')
      
    result = entities&.map do |entity|
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