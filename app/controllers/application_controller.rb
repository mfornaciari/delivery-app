# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def set_shipping_company
    @shipping_company = ShippingCompany.find(params[:shipping_company_id])
  end

  def authenticate_user_or_admin
    authenticate_user! unless admin_signed_in?
  end

  def after_sign_in_path_for(_resource)
    admin_signed_in? ? shipping_companies_path : shipping_company_path(current_user.shipping_company)
  end
end
