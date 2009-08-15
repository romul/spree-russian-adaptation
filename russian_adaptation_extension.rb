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

    Spree::BaseController.class_eval do
       helper RussianHelper
    end

    # admin.tabs.add "Russian Adaptation", "/admin/russian_adaptation", :after => "Layouts", :visibility => [:all]
  end
end

