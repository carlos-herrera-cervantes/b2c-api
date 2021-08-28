class Card < Base
  include Mongoid::Document
  include Mongoid::Pagination

  VALID_CVV_REGEX = /\A[0-9]{3,4}\z/i
  VALID_NUMBERS_REGEX = /\A(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})\z/i
  VALID_EXPIRATION_REGEX = /\A(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})\z/i

  validates :alias, presence: true
  validates :owner, presence: true
  validates :numbers, presence: true, format: { with: VALID_NUMBERS_REGEX }, uniqueness: { case_sensitive: false }, on: :create
  validates :cvv, presence: true, format: { with: VALID_CVV_REGEX }, uniqueness: { case_sensitive: false }, on: :create
  validates :expiration, presence: true, format: { with: VALID_EXPIRATION_REGEX }, uniqueness: { case_sensitive: false }, on: :create

  field :alias, type: String
  field :owner, type: String
  field :numbers, type: String
  field :cvv, type: String
  field :expiration, type: String
  field :token, type: String
  field :default, type: Boolean, default: false
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

  has_many :preorders, dependent: :destroy
  belongs_to :client

  before_save :anonymize_numbers, :set_dates

  protected

  def anonymize_numbers
    numbers = self.numbers

    self.numbers = numbers[-4..-1]
    self.cvv = '***'
    self.expiration = '******'
  end

end