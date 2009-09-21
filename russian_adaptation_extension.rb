# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RussianAdaptationExtension < Spree::Extension
  version "0.1"
  description "Adapts Spree to the Russian reality."
  url "http://github.com/romul/spree-russian-adaptation"

  # Please use russian_adaptation/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem 'russian', :lib => 'russian', :source => 'http://gems.github.com'
  end

  def activate
    
    Time::DATE_FORMATS[:date_time24] = "%d.%m.%Y - %H:%M"
    Time::DATE_FORMATS[:short_date] = "%d.%m.%Y"
    
    # replace .to_url method provided by stringx gem by .parameterize provided by russian gem
    String.class_eval do
      def to_url
        self.parameterize
      end
   	end

    CheckoutsController.class_eval do

      update.failure do
        flash "Возникла непредвиденная ошибка!"
      end

      update.before do
        # update user to current one if user has logged in
        @order.update_attribute(:user, current_user) if current_user

        if (checkout_info = params[:checkout]) and not checkout_info[:coupon_code]
          # overwrite any earlier guest checkout email if user has since logged in
          checkout_info[:email] = current_user.email if current_user

          # and set the ip_address to the most recent one
          checkout_info[:ip_address] = request.env['REMOTE_ADDR']

          set_address(@checkout.bill_address,
                      checkout_info[:bill_address_attributes],
                      current_user ? current_user.bill_address : nil)

          set_address(@order.shipment.address,
                      checkout_info[:shipment_attributes][:address_attributes],
                      current_user ? current_user.ship_address : nil)
        end
        @order.complete! unless params[:final_answer].blank?
      end

      private

        def set_address(current_address, address_params, current_user_address)
            # check whether the address has changed, and start a fresh record if
            # we were using the address stored in the current user.
            if address_params and current_address
              # always include the id of the record we must write to - ajax can't refresh the form
              address_params[:id] = current_address.id
              new_address = Address.new address_params
              if not current_address.same_as?(new_address) and
                   current_user and current_address == current_user_address
                # need to start a new record, so replace the existing one with a blank
                address_params.delete :id
                current_address = Address.new
              end
            end
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
      
      #override r_c default b/c we don't want to actually destroy, we just want to clear line items
      def destroy
        flash[:notice] = I18n.t(:basket_successfully_cleared)
        @order.line_items.clear
        @order.update_totals!
        after :destroy
        response_for :destroy
      end
    end


    Checkout.class_eval do
      def bill_address
        shipment ? shipment.address : Address.default
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
    end
    
    Admin::BaseHelper.module_eval do 
      def text_area(object_name, method, options = {})
        begin
          fckeditor_textarea(object_name, method,
            :toolbarSet => 'Spree', :width => '100%', :height => '350px')
        rescue
          super
        end
      end      
    end

    ResourceController::Controller.module_eval do 
      private
      def self.init_default_actions(klass)
        klass.class_eval do
          index.wants.html
          edit.wants.html
          new_action.wants.html

          show do
            wants.html

            failure.wants.html { render :text => "Запрашиваемая запись не найдена." }
          end

          create do
            flash "Запись успешно создана!"
            wants.html { redirect_to object_url }

            failure.wants.html { render :action => "new" }
          end

          update do
            flash "Запись успешно обновлена!"
            wants.html { redirect_to object_url }

            failure.wants.html { render :action => "edit" }
          end

          destroy do
            flash "Запись успешно удалена!"
            wants.html { redirect_to collection_url }
          end
          
          class << self
            def singleton?
              false
            end
          end
        end
      end            
    end
    # admin.tabs.add "Russian Adaptation", "/admin/russian_adaptation", :after => "Layouts", :visibility => [:all]
  end
end

