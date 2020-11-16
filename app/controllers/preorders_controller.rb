require_relative '../modules/preorder_module.rb'
require 'async/await'

class PreordersController < ApplicationController
  include Async::Await

  before_action :authorize_request
  before_action :validate_pagination, only: [:index]
  before_action :set_preorder, only: [:show, :update, :destroy]

  attr_reader :preorder_repository
  attr_reader :preorder_manager

  def initialize(preorder_repository = PreorderRepository.new, preorder_manager = PreorderManager.new)
    @preorder_repository = preorder_repository
    @preorder_manager = preorder_manager
  end
  
  async def index
    preorders = preorder_repository.get_all_async(request.query_parameters).wait
    render json: { status: true, data: preorders }
  end

  def show
    render json: { status: true, data: @preorder }
  end

  async def create
    merge = {}.merge(set_preorder_params, { 'client_id' => params[:client_id] })
    preorder = preorder_manager.create_async(merge).wait
    render json: { status: true, data: preorder }, status: :created
  end

  async def update
    preorder = preorder_manager.update_async(params[:id], set_preorder_params).wait
    render json: { status: true, data: preorder }, status: :created
  end

  async def destroy
    preorder_manager.delete_async(params[:id]).wait
  end

  private

  async def set_preorder
    @preorder = preorder_repository.get_by_id_async(params[:id]).wait
  rescue => exception
    error = PreorderModule.get_parse_error(exception)
    render json: { status: false, message: error['message'], code: error['code'] }, status: error['status_code']
  end

  def set_preorder_params
    params.require(:preorder).permit(:details, :amount, :station_id, :card_id)
  end

end