module PreorderModule
  extend self

  def get_parse_error(exception)
    case
    when exception.class == Mongoid::Errors::DocumentNotFound
      { 'code' => 'PreorderNotFound', 'message' => 'Pre orden no encontrada', 'status_code' => :not_found }
    end
  end

end