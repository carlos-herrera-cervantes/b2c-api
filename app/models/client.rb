require 'bcrypt'

class Client
  include Mongoid::Document
  include Mongoid::Pagination
  include BCrypt

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, on: :create
  validates :password, presence: true, length: { minimum: 6 }

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password, type: String
  field :gender, type: String, default: 'Sin especificar'
  field :role, type: String, default: 'client'
  field :created_at, type: DateTime, default: DateTime.now
  field :updated_at, type: DateTime, default: DateTime.now

  has_many :cards, dependent: :destroy
  has_many :preorders, dependent: :destroy

  before_save :set_encrypted_password

  protected

  def set_encrypted_password
    self.password = Password.create(self.password)
  end

end