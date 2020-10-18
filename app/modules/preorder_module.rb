module PreorderModule
  extend self

  def get_parse_error(exception)
    case
    when exception.class == Mongoid::Errors::DocumentNotFound
      { 'code' => 'PreorderNotFound', 'message' => I18n.t(:PreorderNotFound), 'status_code' => :not_found }
    end
  end

end