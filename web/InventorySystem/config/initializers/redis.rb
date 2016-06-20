require 'redis'
require 'redis-namespace'

default_db=1
default_db=2 if Rails.env.demo?
default_db=0 if Rails.env.production?

$redis= Redis::Namespace.new('InventorySystem', redis: Redis.new(:host => '127.0.0.1', :port => '6379', :db => default_db))
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      $redis.client.disconnect

      $redis= Redis::Namespace.new('InventorySystem', redis: Redis.new(:host => '127.0.0.1', :port => '6379', :db => default_db))
    end
  end
end