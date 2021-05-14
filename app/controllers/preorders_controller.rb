require_relative '../modules/preorder_module.rb'
require 'async/await'

class PreordersController < ApplicationController
  include Async::Await

  before_action :authorize_request
  before_action :current_user
  before_action :set_preorder, only: [:show, :destroy]

  attr_reader :preorder_repository
  attr_reader :client_repository
  attr_reader :preorder_manager

  def initialize(
    preorder_repository = PreorderRepository.new,
    preorder_manager = PreorderManager.new,
    client_repository = ClientRepository.new
  )
    @preorder_repository = preorder_repository
    @preorder_manager = preorder_manager
    @client_repository = client_repository
  end
  
  async def index
    hash = CommonModule.define_query_params(request.query_parameters, params[:client_id], true)
    page, limit, filter = hash.values_at('page', 'limit', 'filter')

    total_docs = preorder_repository.count_async(filter).wait
    preorders = preorder_repository.get_all_async(hash).wait

    pager = CommonModule.set_paginator(page, limit, total_docs)
    render json: { status: true, data: preorders, pager: pager }
  end

  def show
    render json: { status: true, data: @preorder }
  end

  async def create
    merge = {}.merge(set_preorder_params, { 'client_id' => params[:client_id] })
    preorder = preorder_manager.create_async(merge).wait
    render json: { status: true, data: preorder }, status: :created
  end

  async def destroy
    preorder_manager.delete_async(params[:id]).wait
  end

  private

  async def set_preorder
    if @client['role'] == Roles::CLIENT
      filter = {
        '_id' => BSON::ObjectId.from_string(params[:id]),
        'client_id' => BSON::ObjectId.from_string(params[:client_id])
      }

      @preorder = preorder_repository.get_one_async(filter).wait
    else
      @preorder = preorder_repository.get_by_id_async(params[:id]).wait
    end
  rescue => exception
    error = PreorderModule.get_parse_error(exception)
    render json: { status: false, message: error['message'], code: error['code'] }, status: error['status_code']
  end

  def set_preorder_params
    params.require(:preorder).permit(:details, :amount, :station_id, :card_id)
  end

end