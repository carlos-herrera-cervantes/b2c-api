class Card < Base
  include Mongoid::Document

  validates :alias, presence: true
  validates :numbers, presence: true
  validates :owner, presence: true

  field :alias, type: String
  field :numbers, type: String
  field :owner, type: String
  field :token, type: String
  field :default, type: Boolean, default: false
end