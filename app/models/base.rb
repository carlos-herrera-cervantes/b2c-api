class Base
  include Mongoid::Document

  field :created_at, type: DateTime
  field :updated_at, type: DateTime
end