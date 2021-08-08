require 'async/await'

class ApiKeyController < ApplicationController
  include Async::Await

  before_action :current_user
  before_action :set_client_id

  attr_reader :api_key_repository
  attr_reader :client_repository
  attr_reader :api_key_manager

  def initialize(
    api_key_repository = ApiKeyRepository.new,
    api_key_manager = ApiKeyManager.new,
    client_repository = ClientRepository.new
  )
    @api_key_repository = api_key_repository
    @api_key_manager = api_key_manager
    @client_repository = client_repository
  end

  async def index
    hash = CommonModule.define_query_params(request.query_parameters)
    page, limit, filter = hash.values_at('page', 'limit', 'filter')

    total_docs = api_key_repository.count_async(filter).wait
    keys = api_key_repository.get_all_async(hash).wait

    pager = CommonModule.set_paginator(page, limit, total_docs)
    render json: { status: true, data: keys, pager: pager }
  end
  
  async def show
    key = api_key_repository.get_by_id_async(params[:id]).wait
    render json: { status: true, data: key }
  rescue => exception
    error = CommonModule.parse_error(exception, 'api_key')
    render json: {
      status: false,
      message: error['message'],
      code: error['code']
    }, status: error['status_code']
  end

  async def create
    key = api_key_repository.generate_api_key
    merge = {}.merge(set_api_key_params, { 'api_key' => key })
    api_key = api_key_manager.create_async(merge).wait

    render json: { status: true, data: api_key }, status: :created
  end

  private

  def set_client_id
    if @client['role'] == Roles::CLIENT
      render json: {
        status: false,
        message: I18n.t(:Unauthorized),
        code: 'Unauthorized'
      }, status: :forbidden
    end
  end

  def set_api_key_params
    params.require(:api_key).permit(:name, :role)
  end
end