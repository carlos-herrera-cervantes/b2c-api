require_relative '../modules/preorder_module.rb'

class PreordersController < ApplicationController
  before_action :authorize_request
  before_action :set_preorder, only: [:show, :update, :destroy]

  attr_reader :preorder_repository
  attr_reader :preorder_manager

  def initialize(preorder_repository = PreorderRepository.new, preorder_manager = PreorderManager.new)
    @preorder_repository = preorder_repository
    @preorder_manager = preorder_manager
  end
  
  def index
    preorders = preorder_repository.get_all
    render json: { status: true, data: preorders }
  end

  def show
    render json: { status: true, data: @preorder }
  end

  def create
    merge = {}.merge(set_preorder_params, { 'client_id' => params[:client_id] })
    preorder = preorder_manager.create(merge)
    render json: { status: true, data: preorder }, status: :created
  end

  def update
    preorder = preorder_manager.update(params[:id], set_preorder_params)
    render json: { status: true, data: preorder }, status: :created
  end

  def destroy
    preorder_manager.delete(params[:id])
  end

  private

  def set_preorder
    @preorder = preorder_repository.get_by_id(params[:id])
  rescue => exception
    error = PreorderModule.get_parse_error(exception)
    render json: { status: false, message: error['message'], code: error['code'] }, status: error['status_code']
  end

  def set_preorder_params
    params.require(:preorder).permit(:details, :amount, :station_id, :card_id)
  end

end