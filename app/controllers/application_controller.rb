require_relative '../modules/client_module.rb'
require_relative '../constants/roles.rb'
require 'async/await'

class ApplicationController < ActionController::API
  include Async::Await

  before_action :set_locale

  attr_reader :client_repository

  def initialize(client_repository = ClientRepository.new)
    @client_repository = client_repository
  end

  protected

  def set_locale
    I18n.locale = request.headers['Accept-Language'] || 'en'
  end

  def authorize_request
    token = get_token
    JsonWebToken.decode(token)
  rescue JWT::DecodeError => error
    render json: { status: false, code: 'InvalidToken', message: I18n.t(:InvalidToken) }, status: :unauthorized
  end

  async def current_user
    token = get_token
    decoded = JsonWebToken.decode(token)
    @client = client_repository.get_by_id_async(decoded[:client_id]).wait

    if @client['role'] == Roles::CLIENT
      params[:client_id] = @client['id']
    end
  rescue JWT::DecodeError => error
    render json: { status: false, code: 'InvalidToken', message: I18n.t(:InvalidToken) }, status: :unauthorized
  rescue => exception
    error = ClientModule.get_parse_error(exception)
    render json: { status: false, code: error['code'], message: error['message'] }, status: error['status_code']
  end

  def get_token
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    token
  end

end
