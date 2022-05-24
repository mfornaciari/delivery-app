class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    resource.is_a?(Admin) ? shipping_companies_path : shipping_company_path(current_user.shipping_company)
  end
end
