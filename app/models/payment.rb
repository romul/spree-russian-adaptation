class Payment < ActiveRecord::Base
  belongs_to :order 
  after_save :check_payments
  after_destroy :check_payments
  
  validates_numericality_of :amount
  
  private
  def check_payments                            
    return unless order.checkout_complete       
    order.pay! if order.payment_total >= order.total
  end
end
