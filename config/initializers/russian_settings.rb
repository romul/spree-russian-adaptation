Time.zone = "Moscow"
I18n.default_locale = :'ru-RU'

if Spree::Config.instance
  Spree::Config.set(:products_per_page => 5)
  Spree::Config.set(:default_locale => :'ru-RU')
  Spree::Config.set(:default_country_id => 168)
  Spree::Config.set(:auto_capture => false)
end

PAYMENT_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml'))['payment']
