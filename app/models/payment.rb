class Payment < ApplicationRecord
  include BCrypt

  validate :merchant_password_must_exist
  validates_inclusion_of :merchant_id, in: :merchant_ids

  def merchant_password
    @password ||= Password.new(merchant_password_hash)
  end

  def merchant_password=(new_password)
    @password = Password.create(new_password)
    self.merchant_password_hash = @password
  end

  def merchant_ids
    [1]
  end

  def merchant_password_must_exist
    unless merchant_passwords.detect { |pass| merchant_password == pass }
      errors.add(:merchant_password, "must be in the list of passwords")
    end
  end

  def merchant_passwords
    ["strongpassword"]
  end
end
