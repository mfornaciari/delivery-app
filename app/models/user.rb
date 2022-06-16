# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :shipping_company, optional: true

  before_validation :set_shipping_company

  validate :company_exists

  private

  def set_shipping_company
    domain = email.split('@')[1]
    self.shipping_company = ShippingCompany.find_by(email_domain: domain)
  end

  def company_exists
    return if shipping_company

    errors.add :email, 'não possui um domínio registrado'
  end
end
