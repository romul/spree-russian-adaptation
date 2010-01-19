# encoding: utf-8
require 'active_record/fixtures'

namespace :db do
  desc "Bootstrap your database for Spree."
  task :bootstrap  => :environment do
    # load initial database fixtures (in db/sample/*.yml) into the current environment's database
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    Spree::Setup.create_admin_user('admin', 'admin@admin.ru') if User.count == 0
    Dir.glob(File.join(RussianAdaptationExtension.root, "db", 'sample', '*.{yml,csv}')).each do |fixture_file|
      Fixtures.create_fixtures("#{RussianAdaptationExtension.root}/db/sample", File.basename(fixture_file, '.*'))
    end
  end
end
