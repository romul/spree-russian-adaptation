Time.zone = "Moscow"
I18n.default_locale = :'ru-RU'

Time::DATE_FORMATS[:date_time24] = "%d.%m.%Y - %H:%M"
Time::DATE_FORMATS[:short_date] = "%d.%m.%Y"

if Spree::Config
  Spree::Config.set(:products_per_page => 5)
  Spree::Config.set(:default_locale => :'ru-RU')
  Spree::Config.set(:default_country_id => 168)
end

CalendarDateSelect.format = :euro_24hr

PAYMENT_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml'))['payment']

