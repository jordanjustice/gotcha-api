require "password_encryptor"
require "token_generator"

class Player < ApplicationRecord
  attr_accessor :password

  before_validation :encrypt_password, on: [:create, :update]
  after_save :clear_virtual_password

  validates :email_address, presence: true,
                            format: { with: Validations::Email },
                            uniqueness: { case_sensitive: false,
                                          message: "has already been registered" }
  validates :name, presence: true
  validates :password, presence: true, if: proc { |u| u.crypted_password_changed? }

  def self.authenticate(email_address, password)
    player = with_email_address(email_address)
    return nil unless player
    player if PasswordEncryptor.matches?(password, player.crypted_password, player.salt)
  end

  def self.with_api_key(api_key)
    where(api_key: api_key).first unless api_key.blank?
  end

  def self.with_email_address(email_address)
    where("LOWER(email_address) = :email_address",
          email_address: (email_address || "").downcase).first
  end

  private

  def clear_virtual_password
    self.password = nil
  end

  def encrypt_password
    self.salt = TokenGenerator.generate
    self.crypted_password = PasswordEncryptor.encrypt(self.password, self.salt)
  end
end
