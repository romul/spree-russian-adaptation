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

namespace :spree do
  namespace :extensions do
    namespace :russian_adaptation do
      desc "Copies public assets of the Russian Adaptation to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[RussianAdaptationExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(RussianAdaptationExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end
      
      desc "Загружает необходимые данные в БД."
      task :bootstrap => :environment do
        ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
              
        Country.delete_all
        Role.delete_all 
        State.delete_all
        Zone.delete_all
        ZoneMember.delete_all
        
        Dir.glob(File.join(RussianAdaptationExtension.root, "db", 'default', '*.{yml,csv}')).each do |fixture_file|
          Fixtures.create_fixtures("#{RussianAdaptationExtension.root}/db/default", File.basename(fixture_file, '.*'))
        end
        Spree::Setup.create_admin_user if User.count == 0      
      end  
    end
  end
end
