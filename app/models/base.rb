class Base
  def set_dates
    self.created_at = DateTime.now
    self.updated_at = DateTime.now
  end
end