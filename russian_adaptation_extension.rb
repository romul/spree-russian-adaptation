# encoding: utf-8
# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RussianAdaptationExtension < Spree::Extension
  version "0.1"
  description "Adapts Spree to the Russian reality."
  url "http://github.com/romul/spree-russian-adaptation"

  # Please use russian_adaptation/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem 'russian', :lib => 'russian', :source => 'http://gemcutter.org'
  end

  def activate
    
    Time::DATE_FORMATS[:date_time24] = "%d.%m.%Y - %H:%M"
    Time::DATE_FORMATS[:short_date] = "%d.%m.%Y"
    
    require "active_merchant/billing/gateways/robo_kassa"
    Gateway::RoboKassa.register
    
    # replace .to_url method provided by stringx gem by .parameterize provided by russian gem
    String.class_eval do
      def to_url
        self.parameterize
      end
   	end


    OrdersController.class_eval do
      def sberbank_billing
        if (@order.shipping_method.name =~ /предопл/ && can_access?)
          render :layout => false
        else
          flash[:notice] = 'Счёт не найден.'
          redirect_to root_path
        end
      end     
    end

    Gateway.class_eval do
      def self.current
        self.first :conditions => ["environment = ? AND active = ?", RAILS_ENV, true]
      end
    end

    Checkout.class_eval do
      validation_group :address, :fields=> [
      "ship_address.firstname", "ship_address.lastname", "ship_address.phone", 
      "ship_address.zipcode", "ship_address.state", "ship_address.lastname", 
      "ship_address.address1", "ship_address.city", "ship_address.statename", 
      "ship_address.zipcode", "ship_address.secondname"]
  
      def bill_address
        ship_address || Address.default
      end
    end
    
    Checkout.state_machines[:state] =
        StateMachine::Machine.new(Checkout, :initial => 'address') do
          after_transition :to => 'complete', :do => :complete_order   
          event :next do
            transition :to => 'delivery', :from  => 'address'
            transition :to => 'complete', :from => 'delivery'
          end
        end

    ActionView::Helpers::NumberHelper.module_eval do
      def number_to_currency(number, options = {})
        rub = number.to_i
        kop = ((number - rub)*100).round.to_i
        if (kop > 0)
          "#{rub}&nbsp;#{RUSSIAN_CONFIG['country']['currency']}&nbsp;#{'%.2d' % kop}&nbsp;коп.".mb_chars
        else
          "#{rub}&nbsp;#{RUSSIAN_CONFIG['country']['currency']}".mb_chars
        end
      end
    end
    
    Admin::BaseHelper.module_eval do 
      def text_area(object_name, method, options = {})
        begin
          ckeditor_textarea(object_name, method, :width => '100%', :height => '350px')
        rescue
          super
        end
      end      
    end

    # admin.tabs.add "Russian Adaptation", "/admin/russian_adaptation", :after => "Layouts", :visibility => [:all]
  end
end

