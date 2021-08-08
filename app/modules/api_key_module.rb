module ApiKeyModule
  extend self

  def get_parse_error(exception)
    case
    when exception.class == Mongoid::Errors::DocumentNotFound
      { 'code' => 'ApiKeyNotFound', 'message' => I18n.t(:ApiKeyNotFound), 'status_code' => :not_found }
    end
  end

end