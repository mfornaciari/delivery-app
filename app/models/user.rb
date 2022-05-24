class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :shipping_company

  after_initialize :set_shipping_company

  private

  def set_shipping_company
    domain = email.split('@')[1]
    self.shipping_company = ShippingCompany.find_by(email_domain: domain)
  end
end
