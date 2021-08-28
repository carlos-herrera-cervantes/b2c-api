class Preorder < Base
  include Mongoid::Document
  include Mongoid::Pagination

  validates :details, presence: true
  validates :amount, presence: true, numericality: { greater_than: 99 }
  validates :station_id, presence: true

  field :details, type: String
  field :amount, type: Float
  field :tip, type: Float, default: 0
  field :total_amount, type: Float, default: 0
  field :station_id, type: BSON::ObjectId
  field :status, type: String, default: 'pending'
  field :bank_reference, type: String
  field :card_type, type: String
  field :paid_at, type: DateTime
  field :pre_auth_id, type: String
  field :charge_amount, type: Float
  field :charged_at, type: DateTime
  field :post_auth_id, type: String
  field :cancel_at, type: DateTime
  field :cancel_auth_id, type: String
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  belongs_to :card
  belongs_to :client

  before_save :set_dates
end