class Preorder < Base
  include Mongoid::Document

  field :details, type: String
  field :amount, type: Decimal
  field :tip, type: Decimal
  field :total_amount, type: Decimal
  field :station_id, type: ObjectId
  field :status, type: String, Default: 'pending'
  field :bank_reference, type: String
  field :card_type, type: String
  field :paid_at, type: DateTime
  field :pre_auth_id, type: String
  field :charge_amount, type: Decimal
  field :charged_at, type: DateTime
  field :post_auth_id, type: String
  field :cancel_at, type: DateTime
  field :cancel_auth_id, type: String
end