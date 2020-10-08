module CardModule
  extend self

  def get_parse_error(exception)
    case
    when exception.class == Mongoid::Errors::DocumentNotFound
      { 'code' => 'CardNotFound', 'message' => 'Tarjeta no encontrada', 'status_code' => :not_found }
    end
  end

end