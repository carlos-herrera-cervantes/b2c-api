require 'async/await'

class ClientsController < ApplicationController
  include Async::Await
  
  before_action :current_user, except: :create
  before_action :set_client_id, except: :create

  attr_reader :client_repository
  attr_reader :client_manager

  def initialize(
    client_repository = ClientRepository.new,
    client_manager = ClientManager.new
  )
    @client_repository = client_repository
    @client_manager = client_manager
  end

  async def index
    hash = CommonModule.define_query_params(
      request.query_parameters,
      @id
    )

    page, limit, filter = hash.values_at('page', 'limit', 'filter')

    total_docs = client_repository.count_async(filter).wait
    clients = client_repository.get_all_async(hash).wait

    pager = CommonModule.set_paginator(page, limit, total_docs)
    render json: {
      status: true,
      data: clients,
      pager: pager
    }, except: [:password]
  end

  def show
    render json: { status: true, data: @inner_client }, except: [:password]
  end

  async def create
    client = client_manager.create_async(set_client_params).wait
    render json: {
      status: true,
      data: client
    }, status: :created, except: [:password]
  end

  async def update
    client = client_manager.update_async(
      @id,
      set_client_params
    ).wait
    render json: { status: true, data: client }, except: [:password]
  end

  async def destroy
    client_manager.delete_async(@id).wait
  end

  private

  async def set_client_id
    @id = @client['role'] == Roles::CLIENT ? 
      @client['id'] :
      params[:id] ? params[:id] :
      false

    if @id
      @inner_client = client_repository.get_by_id_async(@id).wait
    end
  rescue => exception
    error = CommonModule.parse_error(exception, 'client')
    render json: {
      status: false,
      message: error['message'],
      code: error['code']
    }, status: error['status_code']
  end

  def set_client_params
    params.require(:client).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :gender,
      :role
    )
  end

end