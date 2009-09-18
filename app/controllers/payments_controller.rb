class PaymentsController < Spree::BaseController
  before_filter :load_robokassa
  
  def show
    @order = Order.find_by_number(params[:id])
  end

  def result
    if @robo_kassa.result?(params)
       @status_operation = @robo_kassa.state_operation(params)
       @order = Order.find_by_number('R' + params[:InvId])
       if (@status_operation[:state].to_i == 100)
         payment = Payment.new(:amount => params[:OutSum])
         payment.order = @order
         if payment.save
           render :text => "OK#{params[:InvId]}", :status => :ok
         else
           render :text => "Payment not saved", :status => :ok
         end
         
       else
         render :text => "Status <> 100, = #{@status_operation[:state]}", :status => :ok
       end
      
    else
      render :text => "Signature is invalid", :status => :ok
    end
    
  end

  def success
    @order = Order.find_by_number('R' + params[:InvId])    
    if @robo_kassa.success?(params)
      flash[:notice] = 'Платёж принят, спасибо!'     
    else
      flash[:error] = 'Платёж не прошёл проверку подписи.'
    end
    redirect_to home_url unless @order
    redirect_to order_url(@order.number)
  end
  
  def fail
    @order = Order.find_by_number('R' + params[:InvId])
    flash[:error] = 'Платёж не завершен или отменён.'
    redirect_to home_url unless @order
    redirect_to order_url(@order.number)
  end



    
  private 

  def accurate_title
    "Платежи"
  end
  
  def load_robokassa
    robo_settings = PAYMENT_CONFIG['robokassa'].symbolize_keys
    @robo_kassa = ActiveMerchant::Billing::RoboKassaGateway.new(robo_settings)
  end

end
