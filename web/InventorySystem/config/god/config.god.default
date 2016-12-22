RAILS_ENV  = ENV['RAILS_ENV']  = 'development'
RAILS_ROOT = ENV['RAILS_ROOT'] = '/webApps/inventory/web/InventorySystem'
PID_DIR    = "#{RAILS_ROOT}/tmp/pids"
BUNDLE_BIN_PATH   = "/home/qingpu/.rvm/gems/ruby-2.1.5@global/bin/"
#UID = 'charloddt'
#GID = 'charlot'

God.pid_file_directory = "#{RAILS_ROOT}/tmp/pids"

God.log_file  = "#{RAILS_ROOT}/log/god.log"
God.log_level = :info

%w(sidekiq).each do |config|
  God.load "#{RAILS_ROOT}/config/god/#{config}.god"
end
