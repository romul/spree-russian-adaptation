# encoding: utf-8
class OrderMailer < ActionMailer::QueueMailer
  helper "spree/base"
  helper "hook"

  def confirm(order, resend = false)
    @subject    = (resend ? "[RESEND] " : "") 
    @subject    += Spree::Config[:site_name] + ' :: Уведомление о заказе #' + order.number
    @body       = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
    @content_type = "text/html"
  end
  
  def cancel(order)
    @subject    = Spree::Config[:site_name] + ' :: Отмена заказа #' + order.number
    @body       = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
    @content_type = "text/html"
  end  
  
  private
  def order_bcc
      bcc = [Spree::Config[:order_bcc] || "", Spree::Config[:mail_bcc] || ""]
      bcc = bcc.inject([]){|array, config_string| array + config_string.split(",")}
      bcc = bcc.collect{|email| email.strip}
      bcc = bcc.uniq
      bcc
  end
end
