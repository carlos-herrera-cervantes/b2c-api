require_relative '../modules/client_module.rb'

class ApplicationController < ActionController::API
  before_action :set_locale

  attr_reader :client_repository

  def initialize(client_repository = ClientRepository.new)
    @client_repository = client_repository
  end

  protected

  def validate_pagination
    exists_paginate = request.query_parameters.key?('paginate')
    
    unless exists_paginate
      return
    end

    exists_page = request.query_parameters.key?('page')
    exists_page_size = request.query_parameters.key?('page_size')
    
    if exists_paginate and (not exists_page or not exists_page_size)
      render json: { status: false, code: 'MissingPaginateParams', message: I18n.t(:MissingPaginateParams) }, status: :bad_request
      return
    end

    page = request.query_parameters['page'].to_i
    page_size = request.query_parameters['page_size'].to_i
    
    if page < 1 or page_size < 1 or page_size > 100
      render json: { status: false, code: 'InvalidPagination', message: I18n.t(:InvalidPagination) }, status: :bad_request
    end
  end

  def set_locale
    I18n.locale = request.headers['Accept-Language'] || 'en'
  end

  def authorize_request
    token = get_token
    JsonWebToken.decode(token)
  rescue JWT::DecodeError => error
    render json: { status: false, code: 'InvalidToken', message: I18n.t(:InvalidToken) }, status: :unauthorized
  end

  def current_user
    token = get_token
    decoded = JsonWebToken.decode(token)
    @client = client_repository.get_by_id(decoded[:client_id])
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
