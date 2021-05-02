module ClientModule
  extend self

  def get_parse_error(exception)
    case
    when exception.class == Mongoid::Errors::DocumentNotFound
      {
        'code' => 'ClientNotFound',
        'message' => I18n.t(:ClientNotFound),
        'status_code' => :not_found
      }
    else
      {
        'code' => 'InternalServerError',
        'message' => I18n.t(:InternalServerError),
        'status_code' => :internal_server_error
      }
    end
  end

end