class Card
  include Mongoid::Document

  validates :alias, presence: true
  validates :numbers, presence: true
  validates :owner, presence: true

  field :alias, type: String
  field :numbers, type: String
  field :owner, type: String
  field :token, type: String
  field :default, type: Boolean, default: false
  field :created_at, type: DateTime, default: DateTime.now
  field :updated_at, type: DateTime, default: DateTime.now

  has_many :preorders, dependent: :destroy
  belongs_to :client
end