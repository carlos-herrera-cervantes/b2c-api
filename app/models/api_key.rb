class ApiKey
  include Mongoid::Document
  include Mongoid::Pagination

  validates :name, presence: true
  validates :api_key, presence: true

  field :name, type: String
  field :api_key, type: String
  field :role, type: String, default: 'client'
  field :created_at, type: DateTime, default: DateTime.now
  field :updated_at, type: DateTime, default: DateTime.now
end