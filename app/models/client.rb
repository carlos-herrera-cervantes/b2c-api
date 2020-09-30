class Client < Base
  include Mongoid::Document

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :password, presence: true

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password, type: String
  field :gender, type: String, default: 'Sin especificar'
end