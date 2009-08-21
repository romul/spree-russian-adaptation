class Admin::PaymentsController < Admin::BaseController
  resource_controller
  belongs_to :order
  ssl_required
  
  create.wants.html { redirect_to admin_order_payments_url(object.order) } 
  update.wants.html { redirect_to admin_order_payments_url(object.order) }

end
