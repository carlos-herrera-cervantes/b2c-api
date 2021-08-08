require 'async/await'

class ApplicationController < ActionController::API
  include Async::Await

  before_action :set_locale

  attr_reader :api_key_repository

  def initialize(client_repository = ClientRepository.new)
    @client_repository = client_repository
  end

  protected

  def set_locale
    I18n.locale = request.headers['Accept-Language'] || 'en'
  end

  async def current_user
    header = request.headers['Authorization']
    api_key_header = request.headers['x-api-key']

    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token) if !api_key_header

    api_key = ApiKeyRepository.new.get_one_async({
      'api_key' => api_key_header
    }).wait if api_key_header
    
    @client = api_key ? client_repository
      .get_one_async({ 'role' => api_key['role'] })
      .wait :
      client_repository
      .get_by_id_async(decoded[:client_id])
      .wait

    if @client['role'] == Roles::CLIENT
      params[:client_id] = @client['id']
    end
  rescue JWT::DecodeError => error
    render json: {
      status: false,
      code: 'InvalidToken',
      message: I18n.t(:InvalidToken)
    }, status: :unauthorized
  rescue => exception
    error = CommonModule.parse_error(exception)
    render json: {
      status: false,
      code: error['code'],
      message: error['message']
    }, status: error['status_code']
  end

end
