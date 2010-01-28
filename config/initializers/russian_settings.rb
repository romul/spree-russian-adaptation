Time.zone = "Moscow"
I18n.default_locale = :'ru-RU'

if Spree::Config.instance
  Spree::Config.set(:default_locale => :'ru-RU')
  Spree::Config.set(:default_country_id => 168)
  Spree::Config.set(:auto_capture => false)
  Spree::Config.set(:ship_form_requires_state => true)
end

begin
  PAYMENT_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml'))['payment']
rescue
  PAYMENT_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml.example'))['payment']  
end

ActiveMerchant::Billing::Base.mode = (RAILS_ENV == 'production') ? :live : :test
