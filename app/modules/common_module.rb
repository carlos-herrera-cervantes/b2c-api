require 'json'

module CommonModule
  extend self

  def define_query_params(query_params, client_id = false, is_foreign = false)
    relation = query_params['with']
    
    page = query_params['page'].to_i <= 1 ?
      0 :
      query_params['page'].to_i - 1
    
    limit = query_params.key?('page_size') ?
      query_params['page_size'].to_i > 100 ?
      100 :
      query_params['page_size'].to_i :
      10
    
    sort = query_params.key?('sort') ?
      JSON.parse(query_params['sort']) :
      { "created_at" => -1 }
    
    filter = query_params.key?('filter') ?
      JSON.parse(query_params['filter']) :
      {}

    if client_id && is_foreign
      filter['client_id'] = BSON::ObjectId.from_string(client_id)
    end

    if client_id && !is_foreign
      filter['_id'] = BSON::ObjectId.from_string(client_id)
    end

    {
      'relation' => relation,
      'page' => page * limit,
      'limit' => limit,
      'sort' => sort,
      'filter' => filter
    }
  end

  def set_paginator(page, limit, total_docs)
    clone_page = page + 1
    take = clone_page * limit

    {
      'page' => clone_page,
      'page_size' => limit < 1 ? 10 : limit > 100 ? 100 : limit,
      'remaining_documents' => (total_docs - take) <= 0 ? 0 : total_docs - take,
      'total_documents' => total_docs
    }
  end

  def parse_error(exception, model = false)
    is_document_not_found = exception.class == Mongoid::Errors::DocumentNotFound
    
    if is_document_not_found && model == 'api_key'
      {
        'code' => 'ApiKeyNotFound',
        'message' => I18n.t(:ApiKeyNotFound),
        'status_code' => :not_found
      }
    elsif is_document_not_found && model == 'client'
      {
        'code' => 'ClientNotFound',
        'message' => I18n.t(:ClientNotFound),
        'status_code' => :not_found
      }
    elsif is_document_not_found && model == 'card'
      {
        'code' => 'CardNotFound',
        'message' => I18n.t(:CardNotFound),
        'status_code' => :not_found
      }
    elsif is_document_not_found && model == 'preorder'
      {
        'code' => 'PreorderNotFound',
        'message' => I18n.t(:PreorderNotFound),
        'status_code' => :not_found
      }
    else
      {
        'code' => 'InternalServerError',
        'message' => I18n.t(:InternalServerError),
        'status_code' => :internal_server_error
      }
    end
  end

end