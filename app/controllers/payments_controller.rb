class PaymentsController < Spree::BaseController
  before_filter :load_robokassa
  
  def show
    load_order_by_number(params[:id])
  end

  def result
    if @robo_kassa.result?(params)
      load_order_by_number('R' + params[:InvId])
      render :text => "OK#{params[:InvId]}", :status => :ok 
    else
      render :text => "Signature is invalid", :status => :ok
    end 
  end

  def success
    load_order_by_number('R' + params[:InvId])
    if @robo_kassa.success?(params)
      payment = Payment.new(:amount => params[:OutSum])
      payment.order = @order
      payment.save
      flash[:notice] = 'Платёж принят, спасибо!'
    else
      flash[:error] = 'Платёж не прошёл проверку подписи.'
    end
    redirect_to order_url(@order.number)
  end
  
  def fail
    load_order_by_number('R' + params[:InvId])
    flash[:error] = 'Платёж не завершен или отменён.'
    redirect_to order_url(@order.number)
  end

  private 

  def accurate_title
    "Платежи"
  end
  
  def load_order_by_number(number)
    @order = Order.find_by_number(number)
    unless @order
      flash[:error] = "Заказ с номером #{number} не найден."
      redirect_to root_url
    end
  end
  
  def load_robokassa
    @robo_kassa = Gateway.current.provider
  end

end
