module RelationsModule

  extend self

  def get_relation_by_model(typeModel)
    case typeModel
    when 'client'
      get_relations_for_clients
    when 'card'
      get_relations_for_cards
    when 'preorder'
      get_relations_for_preorders
    end
  end

  #region snippet_Clients

  def get_relations_for_clients
    localField = '_id'
    foreignField = 'client_id'

    {
      'cards' => {
        'localField' => localField,
        'foreignField' => foreignField
      },
      'preorders' => {
        'localField' => localField,
        'foreignField' => foreignField
      }
    }
  end

  #endregion

  #region snippet_Cards

  def get_relations_for_cards
    {
      'clients' => {
        'localField' => 'client_id',
        'foreignField' => '_id'
      },
      'preorders' => {
        'localField' => '_id',
        'foreignField' => 'card_id'
      }
    }
  end

  #endregion

  #region snippet_Preorders

  def get_relations_for_preorders
    {
      'clients' => {
        'localField' => 'client_id',
        'foreignField' => '_id'
      },
      'cards' => {
        'localField' => 'card_id',
        'foreignField' => '_id'
      }
    }
  end

  #endregion

end