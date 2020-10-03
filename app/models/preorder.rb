class Preorder
  include Mongoid::Document

  validates :details, presence: true
  validates :amount, presence: true
  validates :tip, presence: true
  validates :station_id, presence: true

  field :details, type: String
  field :amount, type: Float
  field :tip, type: Float
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
  field :created_at, type: DateTime, default: DateTime.now
  field :updated_at, type: DateTime, default: DateTime.now

  belongs_to :card
  belongs_to :client
end