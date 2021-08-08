require 'async/await'

class CardsController < ApplicationController
  include Async::Await
 
  before_action :current_user
  before_action :set_card, only: [:show, :update, :destroy]

  attr_reader :card_repository
  attr_reader :client_repository
  attr_reader :card_manager

  def initialize(
    card_repository = CardRepository.new,
    card_manager = CardManager.new,
    client_repository = ClientRepository.new
  )
    @card_repository = card_repository
    @card_manager = card_manager
    @client_repository = client_repository
  end

  async def index
    hash = CommonModule.define_query_params(
      request.query_parameters,
      params[:client_id], true
    )
    page, limit, filter = hash.values_at('page', 'limit', 'filter')

    total_docs = card_repository.count_async(filter).wait
    cards = card_repository.get_all_async(hash).wait

    pager = CommonModule.set_paginator(page, limit, total_docs)
    render json: {
      status: true,
      data: cards,
      pager: pager
    }, except: [:token]
  end

  def show
    render json: { status: true, data: @card }, except: [:token]
  end

  async def create
    merge = {}.merge(set_card_params,
    {
      'client_id' => params[:client_id]
    })
    card = card_manager.create_async(merge).wait

    render json: {
      status: true,
      data: card
    }, status: :created, except: [:token]
  end

  async def update
    card = card_manager.update_async(
      params[:id],
      set_card_params
    ).wait

    render json: { status: true, data: card }, status: :created
  end

  async def destroy
    card_manager.delete_async(params[:id]).wait
  end

  private

  async def set_card
    if @client['role'] == Roles::CLIENT
      filter = {
        '_id' => BSON::ObjectId.from_string(params[:id]),
        'client_id' => BSON::ObjectId.from_string(params[:client_id])
      }

      @card = card_repository.get_one_async(filter).wait
    else
      @card = card_repository.get_by_id_async(params[:id]).wait
    end
  rescue => exception
    error = CommonModule.parse_error(exception, 'card')
    render json: {
      status: false,
      message: error['message'],
      code: error['code']
    }, status: error['status_code']
  end

  def set_card_params
    params.require(:card).permit(
      :alias,
      :numbers,
      :owner,
      :cvv,
      :expiration,
      :default
    )
  end

end