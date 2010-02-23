begin
  RUSSIAN_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml'))
rescue
  RUSSIAN_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml.example'))
end

Time.zone = RUSSIAN_CONFIG['country']['timezone']
I18n.default_locale = :'ru-RU'
locale = File.join(File.dirname(__FILE__), '..', 'locales', RUSSIAN_CONFIG['country']['id'], 'ru-RU.yml')
I18n.load_path << locale if File.exists?(locale) and !I18n.load_path.include?(locale)

if Spree::Config.instance
  Spree::Config.set(:default_locale => :'ru-RU')
  Spree::Config.set(:default_country_id => RUSSIAN_CONFIG['country']['id'])
  Spree::Config.set(:auto_capture => false)
  Spree::Config.set(:ship_form_requires_state => true)
end

ActiveMerchant::Billing::Base.mode = (RAILS_ENV == 'production') ? :live : :test
