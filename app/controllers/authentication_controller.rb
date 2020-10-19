require_relative '../modules/client_module.rb'
require 'bcrypt'

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  attr_reader :client_repository

  def initialize(client_repository = ClientRepository.new)
    @client_repository = client_repository
  end

  def login
    client = client_repository.get_one('email' => params[:email])
    compared_password = BCrypt::Password.new(client.password)

    unless compared_password == params[:password]
      return render json: { status: false, code: 'InvalidCredentials', message: I18n.t(:InvalidCredentials) }
    end
    
    token = JsonWebToken.encode(client_id: client.id)
    time = Time.now + 24.hours.to_i
    render json: { status: true, data: token }
  rescue => exception
    error = ClientModule.get_parse_error(exception)
    render json: { status: false, code: error['code'], message: error['message'] }, status: error['status_code']
  end

  def logout
    render json: { status: true, message: 'OK'}, status: :no_content
  end

end