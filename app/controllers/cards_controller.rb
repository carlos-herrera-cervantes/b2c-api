class CardsController < ApplicationController
  before_action :set_card, only: [:show, :update, :destroy]

  attr_reader :card_repository
  attr_reader :card_manager

  def initialize(card_repository = CardRepository.new, card_manager = CardManager.new)
    @card_repository = card_repository
    @card_manager = card_manager
  end

  def index
    cards = card_repository.get_all
    render json: { status: true, data: cards }, except: [:token]
  end

  def show
    render json: { status: true, data: @card }, except: [:token]
  end

  def create
    merge = {}.merge(set_card_params, { 'client_id' => params[:client_id] })
    card = card_manager.create(merge)
    render json: { status: true, data: card }, status: :created, except: [:token]
  end

  def update
    card = card_manager.update(params[:id], set_card_params)
    render json: { status: true, data: card }, status: :created
  end

  def destroy
    card_manager.delete(params[:id])
  end

  private

  def set_card
    @card = card_repository.get_by_id(params[:id])
  rescue => exception
    render json: { status: false, message: exception, code: 'TEST' }, status: :internal_server_error
  end

  def set_card_params
    params.require(:card).permit(:alias, :numbers, :owner)
  end

end