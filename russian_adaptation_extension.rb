# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RussianAdaptationExtension < Spree::Extension
  version "0.1"
  description "Adapts Spree to the Russian reality."
  url "http://yourwebsite.com/russian_adaptation"

  # Please use russian_adaptation/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem 'russian', :lib => 'russian', :source => 'http://gems.github.com'
  end

  def activate
    # replace .to_url method provided by stringx gem by .parameterize provided by russian gem
    String.class_eval do
      def to_url
        self.parameterize
      end
   	end

    OrdersController.class_eval do
      def sberbank_billing
        if (@order.shipping_method.name =~ /предопл/ &&
            @order.user && current_user.email == @order.user.email)
          render :layout => false
        else
          flash[:notice] = 'Счёт не найден.'
          redirect_to root_path
        end
      end
    end

    Spree::BaseHelper.module_eval do
      def number_to_currency(number)
        rub = number.to_i
        kop = ((number - rub)*100).round.to_i
        if (kop > 0)
          "#{rub}&nbsp;p.&nbsp;#{'%.2d' % kop}&nbsp;коп."
        else
          "#{rub}&nbsp;p."
        end
      end

      def text_area(object_name, method, options = {})
        begin
          fckeditor_textarea(object_name, method,
            :toolbarSet => 'Easy', :width => '100%', :height => '350px')
        rescue
          super
        end
      end
    end

    # admin.tabs.add "Russian Adaptation", "/admin/russian_adaptation", :after => "Layouts", :visibility => [:all]
  end
end

