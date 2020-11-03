require_relative '../modules/client_module.rb'

class ClientsController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :validate_pagination, only: [:index]
  before_action :set_client, only: [:show, :update, :destroy]

  attr_reader :client_repository
  attr_reader :client_manager

  def initialize(client_repository = ClientRepository.new, client_manager = ClientManager.new)
    @client_repository = client_repository
    @client_manager = client_manager
  end

  def index
    clients = client_repository.get_all(request.query_parameters)
    render json: { status: true, data: clients }, except: [:password]
  end

  def show
    render json: { status: true, data: @client }, except: [:password]
  end

  def create
    client = client_manager.create(set_client_params)
    render json: { status: true, data: client }, status: :created, except: [:password]
  end

  def update
    client = client_manager.update(params[:id], set_client_params)
    render json: { status: true, data: client }, status: :created
  end

  def destroy
    client_manager.delete(params[:id])
  end

  private

  def set_client
    @client = client_repository.get_by_id(params[:id])
  rescue => exception
    error = ClientModule.get_parse_error(exception)
    render json: { status: false, message: error['message'], code: error['code'] }, status: error['status_code']
  end

  def set_client_params
   params.require(:client).permit(:first_name, :last_name, :email, :password, :gender)
  end

end