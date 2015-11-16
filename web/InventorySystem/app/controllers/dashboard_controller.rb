include ActionView::Helpers::NumberHelper
class DashboardController < ApplicationController
  def index
   
    @check_qty_progress = Inventory.where("check_qty != ''").group('date(check_time)').count(:id)
    # @check_qty_progress = Inventory.where("check_qty != ''").group("date_format(check_time, '%Y-%m-%d')").count(:id).map {|check_time, count_id| [check_time, (count_id/Inventory.where("check_qty != ''").count.to_f * 100).round(0)] }
    
    @check_qty_tmp = @check_qty_progress.collect { |item| {:name => "#{item[0]}:#{item[1]}", :y => item[1]} }
    @check_qty_tmp << {:name => "未全盘:#{Inventory.where("check_qty is null").count(:id)}", :y => Inventory.where("check_qty is null").count(:id)}
    
    puts "the hash array json #{@check_qty_tmp}"
    
    # puts @check_qty_progress
    #@check_qty_progress['未全盘'] = Inventory.where("check_qty is null").count(:id)
    
    
    @random_check_qty_progress = Inventory.random_check_completed.group('date(random_check_time)').count(:random_check_qty)
    # @random_check_qty_progress['未抽盘'] = Inventory.random_check.count(:id)
    # @random_check_qty_progress['未抽盘'] = Inventory.random_check_not.count(:id)
    @random_check_qty_tmp = @random_check_qty_progress.collect { |item| {:name => "#{item[0]}:#{item[1]}", :y => item[1]} }
    @random_check_qty_tmp << {:name => "未抽盘:#{Inventory.random_check_not.count(:id)}", :y => Inventory.random_check_not.count(:id)}
    
    @check_qty_hour_progress = Inventory.where("check_qty != ''").group("date_format(check_time, '%Y-%m-%d %H点')").count(:id)
    @random_check_qty_hour_progress = Inventory.random_check_completed.group("date_format(random_check_time, '%Y-%m-%d %H点')").count(:id)
   
  end
end
