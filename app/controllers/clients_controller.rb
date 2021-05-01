require_relative '../modules/client_module.rb'
require_relative '../constants/roles.rb'
require 'async/await'

class ClientsController < ApplicationController
  include Async::Await
  
  before_action :authorize_request, except: :create
  before_action :current_user

  attr_reader :client_repository
  attr_reader :client_manager

  def initialize(client_repository = ClientRepository.new, client_manager = ClientManager.new)
    @client_repository = client_repository
    @client_manager = client_manager
  end

  async def index
    hash = CommonModule.define_query_params(request.query_parameters, @client)
    page, limit = hash.values_at('page', 'limit')

    total_docs = client_repository.count_async().wait
    clients = client_repository.get_all_async(hash).wait

    pager = CommonModule.set_paginator(page, limit, total_docs)
    render json: { status: true, data: clients, pager: pager }, except: [:password]
  end

  def show
    if @client['role'] == Roles::CLIENT
      return render json: { status: true, data: @client }, except: [:password]
    end

    client = client_repository.get_by_id_async(params[:id]).wait
    return render json: { status: true, data: client }, except: [:password]
  end

  async def create
    client = client_manager.create_async(set_client_params).wait
    render json: { status: true, data: client }, status: :created, except: [:password]
  end

  async def update
    if @client['role'] == Roles::CLIENT
      client_manager.update_async(@client['id'], set_client_params).wait
      return render json: { status: true, data: @client }, except: [:password]
    end
    
    client = client_manager.update_async(params[:id], set_client_params).wait
    render json: { status: true, data: client }, except: [:password]
  end

  async def destroy
    if @client['role'] == Roles::CLIENT
      client_manager.delete_async(@client['id']).wait
    end

    client_manager.delete_async(params[:id]).wait
  end

  private

  def set_client_params
   params.require(:client).permit(:first_name, :last_name, :email, :password, :gender)
  end

end